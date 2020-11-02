import { InfoCrudMixin } from 'lin-mizar';
import { merge } from 'lodash';
import { Sequelize, Model } from 'sequelize';
import sequelize from '../lib/db';

class FillRule extends Model {
  toJSON () {
    const origin = {
      id: this.id,
      survey_id: this.survey_id,
      ip: this.ip,
      username: this.username
    };
    return origin;
  }
}

FillRule.init(
  {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    survey_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '问卷id'
    },
    ip: {
      type: Sequelize.STRING(30),
      allowNull: true,
      comment: '限制每个ip可以填几次',
      defaultValue: 0
    },
    username: {
      type: Sequelize.STRING(64),
      allowNull: true,
      defaultValue: null
    }
  },
  merge(
    {
      sequelize,
      tableName: 'fill-rule',
      modelName: 'fill-rule',
      indexes: [{
        name: 'fill_rule_del',
        method: 'BTREE',
        fields: ['survey_id']
      }]
    },
    InfoCrudMixin.options
  )
);

export { FillRule as FillRuleModel };