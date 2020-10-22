import { InfoCrudMixin } from 'lin-mizar';
import { merge } from 'lodash';
import { Sequelize, Model } from 'sequelize';
import sequelize from '../lib/db';
import { Survey } from './survey';

class Rule extends Model {
  toJSON () {
    const origin = {
      id: this.id,
      survey_id: this.survey_id,
      is_copy: this.is_copy,
      is_login: this.is_login,
      limit_ip: this.limit_ip
    };
    return origin;
  }
}

Rule.init(
  {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    survey_id: {
      type: Sequelize.INTEGER,
      unique: true,
      references: {
        model: Survey,
        key: 'id'
      },
      comment: '问卷id'
    },
    is_copy: {
      type: Sequelize.BOOLEAN,
      allowNull: true,
      comment: '是否可以复制',
      defaultValue: false
    },
    is_login: {
      type: Sequelize.BOOLEAN,
      allowNull: true,
      comment: '是否需要登录',
      defaultValue: false
    },
    limit_ip: {
      type: Sequelize.INTEGER,
      allowNull: true,
      comment: '限制每个ip可以填几次',
      defaultValue: 0
    }
  },
  merge(
    {
      sequelize,
      tableName: 'rule',
      modelName: 'rule',
      indexes: [{
        name: 'rule_del',
        method: 'BTREE',
        fields: ['survey_id']
      }]
    },
    InfoCrudMixin.options
  )
);

export { Rule };