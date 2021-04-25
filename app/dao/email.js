import { NotFound } from 'lin-mizar';
import { emailExtime } from '../config/setting';
import { AdminDao } from '../dao/admin';
import { UserEmailModel } from '../model/user-email';

class EmailDao {
  /**
   * 验证邮箱码存入数据库
   * @param {*} user_id
   * @param {*} code
   * @returns email
   */
  async createRenderCode (user_id, code) {
    const email = new UserEmailModel();
    email.user_id = user_id;
    email.code = code;
    email.ex_time = Date.now();
    email.isLive = false;
    await email.save();
  }
  /**
   * 获取邮箱验证码账号
   * @param {*} user_id
   */
  async getEmailCode (user_id) {
    const userEmail = UserEmailModel.findOne({
      where: {
        user_id: user_id
      }
    });
    if (userEmail) {
      return userEmail;
    }
    // 如果没有，那就是第一次注册
    return false;
  }
  /**
   * 验证邮箱验证码是否过期
   * @param {*} user_id
   * @param {*} userEmail
   */
  async validatorExcode (user_id, ex_time) {
    // 如果超过过期时间,默认一天
    if ((Date.now() - ex_time) > emailExtime) {
      // 删除原先的账号
      const adminDao = new AdminDao();
      await adminDao.deleteUser(user_id);
      // 删除验证码数据
      await this.deleteCode(user_id);
      throw new NotFound({
        code: 10501
      });
    }
    return true;
  }

  async activiateEmail (id) {
    const email = await UserEmailModel.findByPk(id);
    if (!email) {
      throw new NotFound({
        code: 10022
      });
    }
    email.islive = true;
    await email.save();
  }

  async deleteCode (id) {
    await UserEmailModel.destroy({
      where: {
        user_id: id
      }
    });
  }
}

export { EmailDao };
