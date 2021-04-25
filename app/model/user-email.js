import { Model, Sequelize } from 'sequelize';
import sequelize from '../lib/db';

class UserEmail extends Model {};

UserEmail.init(
  {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    user_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '用户id'
    },
    code: {
      type: Sequelize.STRING(100),
      allowNull: false,
      comment: '邮箱验证码'
    },
    ex_time: {
      type: Sequelize.DATE,
      allowNull: false,
      comment: '过期时间'
    },
    islive: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
      comment: '是否激活'
    }
  },
  {
    sequelize,
    timestamps: false,
    tableName: 'lin_user_email',
    modelName: 'email_del',
    indexes: [
      {
        name: 'email_del',
        using: 'BTREE',
        fields: ['user_id']
      }
    ]
  }
);

export { UserEmail as UserEmailModel };
