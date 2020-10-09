import { InfoCrudMixin } from 'lin-mizar';
import { merge } from 'lodash';
import { Sequelize, Model } from 'sequelize';
import sequelize from '../lib/db';

class Survey extends Model {
  toJSON () {
    const origin = {
      id: this.id,
      title: this.title,
      status: this.status,
      header_desc: this.header_desc,
      footer_desc: this.footer_desc,
      detail: this.detail,
      create_time: this.create_time
    };
    return origin;
  }
}

Survey.init(
  {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    title: {
      type: Sequelize.STRING(30),
      allowNull: false
    },
    status: {
      type: Sequelize.INTEGER,
      allowNull: true,
      defaultValue: 1
    },
    header_desc: {
      type: Sequelize.STRING(50),
      allowNull: true
    },
    footer_desc: {
      type: Sequelize.STRING(50),
      allowNull: true
    },
    detail: {
      type: Sequelize.JSON,
      allowNull: false
    },
    create_time: {
      type: Sequelize.DATE
    }
  },
  merge(
    {
      sequelize,
      tableName: 'survey',
      modelName: 'survey',
      createdAt: true
    },
    InfoCrudMixin.options
  )
);

export { Survey };