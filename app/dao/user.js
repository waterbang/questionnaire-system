import { Forbidden, generate, NotFound, RepeatException } from 'lin-mizar';
import { has, set, uniq } from 'lodash';
import { Op } from 'sequelize';
import sequelize from '../lib/db';
import { GroupLevel, IdentityType, MountType } from '../lib/type';
import { GroupModel } from '../model/group';
import { GroupPermissionModel } from '../model/group-permission';
import { PermissionModel } from '../model/permission';
import { UserIdentityModel, UserModel } from '../model/user';
import { UserGroupModel } from '../model/user-group';
import Email from '../server/email';

class UserDao {
  async getUserInfos (ctx) {
    // 总用户数
    let data = await UserModel.count();
    // 新增用户数
    let n = await UserModel.count({
      where: {
        create_time: {
          [Op.lt]: new Date(),
          [Op.gt]: new Date(new Date() - 7 * 24 * 60 * 60 * 1000)
        }
      }
    });
    return {
      UserTotal: data,
      newWeekUser: n
    };
  }

  async createUser (v) {
    let user = await UserModel.findOne({
      where: {
        username: v.get('body.username')
      }
    });
    if (user) {
      throw new RepeatException({
        code: 10071
      });
    }
    if (v.get('body.email') && v.get('body.email').trim() !== '') {
      user = await UserModel.findOne({
        where: {
          email: v.get('body.email')
        }
      });
      if (user) {
        throw new RepeatException({
          code: 10076
        });
      }
    }
    for (const id of v.get('body.group_ids') || []) {
      const group = await GroupModel.findByPk(id);
      if (group.level === GroupLevel.Root) {
        throw new Forbidden({
          code: 10073
        });
      }
      if (!group) {
        throw new NotFound({
          code: 10023
        });
      }
    }
    const user_id = await this.registerUser(v);
    await Email.createEmail(user_id, v.get('body.email'));
  }

  async updateUser (ctx, v) {
    const user = ctx.currentUser;
    if (v.get('body.username') && user.username !== v.get('body.username')) {
      const exit = await UserModel.findOne({
        where: {
          username: v.get('body.username')
        }
      });
      if (exit) {
        throw new RepeatException({
          code: 10071
        });
      }
      user.username = v.get('body.username');
    }
    if (v.get('body.email') && user.email !== v.get('body.email')) {
      const exit = await UserModel.findOne({
        where: {
          email: v.get('body.email')
        }
      });
      if (exit) {
        throw new RepeatException({
          code: 10076
        });
      }
      user.email = v.get('body.email');
    }
    if (v.get('body.nickname')) {
      user.nickname = v.get('body.nickname');
    }
    if (v.get('body.avatar')) {
      user.avatar = v.get('body.avatar');
    }
    await user.save();
  }

  async getInformation (ctx) {
    const user = ctx.currentUser;

    const userGroup = await UserGroupModel.findAll({
      where: {
        user_id: user.id
      }
    });
    const groupIds = userGroup.map(v => v.group_id);
    const groups = await GroupModel.findAll({
      where: {
        id: {
          [Op.in]: groupIds
        }
      }
    });

    set(user, 'groups', groups);
    return user;
  }

  async getPermissions (ctx) {
    const user = ctx.currentUser;
    const userGroup = await UserGroupModel.findAll({
      where: {
        user_id: user.id
      }
    });
    const groupIds = userGroup.map(v => v.group_id);

    const root = await GroupModel.findOne({
      where: {
        level: GroupLevel.Root,
        id: {
          [Op.in]: groupIds
        }
      }
    });

    set(user, 'admin', !!root);

    let permissions = [];

    if (root) {
      permissions = await PermissionModel.findAll({
        where: {
          mount: MountType.Mount
        }
      });
    } else {
      const groupPermission = await GroupPermissionModel.findAll({
        where: {
          group_id: {
            [Op.in]: groupIds
          }
        }
      });

      const permissionIds = uniq(groupPermission.map(v => v.permission_id));

      permissions = await PermissionModel.findAll({
        where: {
          id: {
            [Op.in]: permissionIds
          },
          mount: MountType.Mount
        }
      });
    }

    set(user, 'permissions', this.formatPermissions(permissions));

    return user;
  }

  async registerUser (v) {
    let transaction;
    let id;
    try {
      transaction = await sequelize.transaction();
      const user = {
        username: v.get('body.username')
      };
      if (v.get('body.email') && v.get('body.email').trim() !== '') {
        user.email = v.get('body.email');
      }
      const { id: user_id } = await UserModel.create(user, {
        transaction
      });
      id = user_id;
      await UserIdentityModel.create(
        {
          user_id,
          identity_type: IdentityType.Password,
          identifier: user.username,
          credential: generate(v.get('body.password'))
        },
        {
          transaction
        }
      );

      const groupIds = v.get('body.group_ids');
      if (groupIds && groupIds.length > 0) {
        for (const id of v.get('body.group_ids') || []) {
          await UserGroupModel.create(
            {
              user_id,
              group_id: id
            },
            {
              transaction
            }
          );
        }
      } else {
        // 未指定分组，默认加入游客分组
        const guest = await GroupModel.findOne({
          where: {
            level: GroupLevel.Guest
          }
        });
        await UserGroupModel.create({
          user_id,
          group_id: guest.id
        });
      }
      await transaction.commit();
    } catch (error) {
      if (transaction) await transaction.rollback();
    }
    return id;
  }

  formatPermissions (permissions) {
    const map = {};
    permissions.forEach(v => {
      const module = v.module;
      if (has(map, module)) {
        map[module].push({
          permission: v.name,
          module
        });
      } else {
        set(map, module, [
          {
            permission: v.name,
            module
          }
        ]);
      }
    });
    return Object.keys(map).map(k => {
      const tmp = Object.create(null);
      set(tmp, k, map[k]);
      return tmp;
    });
  }
}

export { UserDao };
