import { InfoCrudMixin } from 'lin-mizar';
import { merge } from 'lodash';
import { Sequelize, Model } from 'sequelize';
import sequelize from '../lib/db';
import { Survey } from './survey';

class Fill extends Model {
  toJSON () {
    const origin = {
      id: this.id,
      survey_id: this.survey_id,
      detail: this.detail
    };
    return origin;
  }
}

Fill.init(
  {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    survey_id: {
      type: Sequelize.INTEGER,
      references: {
        model: Survey,
        key: 'id'
      },
      comment: '问卷id'
    },
    detail: {
      type: Sequelize.JSON,
      allowNull: false
    }
  },
  merge(
    {
      sequelize,
      tableName: 'fill',
      modelName: 'fill',
      indexes: [{
        name: 'fill_del',
        method: 'BTREE',
        fields: ['survey_id']
      }]
    },
    InfoCrudMixin.options
  )
);

export { Fill as FillModel };