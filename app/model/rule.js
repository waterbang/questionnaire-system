import { InfoCrudMixin } from 'lin-mizar';
import { merge } from 'lodash';
import { Sequelize, Model } from 'sequelize';
import sequelize from '../lib/db';

class Rule extends Model {
  toJSON () {
    const origin = {
      id: this.id,
      is_copy: this.is_copy,
      is_login: this.is_login,
      limit_ip: this.limit_ip,
      remind_wx: this.remind_wx,
      start_time: this.start_time,
      close_time: this.close_time
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
    is_copy: {
      type: Sequelize.BOOLEAN,
      allowNull: true,
      defaultValue: false
    },
    is_login: {
      type: Sequelize.BOOLEAN,
      allowNull: true,
      defaultValue: false
    },
    limit_ip: {
      type: Sequelize.inTEGER,
      allowNull: true,
      defaultValue: 0
    },
    remind_wx: {
      type: Sequelize.BOOLEAN,
      allowNull: true
    },
    start_time: {
      type: Sequelize.DATE,
      allowNull: true
    },
    close_time: {
      type: Sequelize.DATE,
      allowNull: true
    }
  },
  merge(
    {
      sequelize,
      tableName: 'rule',
      modelName: 'rule'
    },
    InfoCrudMixin.options
  )
);

export { Rule };