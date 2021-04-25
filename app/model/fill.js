import { InfoCrudMixin } from 'lin-mizar';
import { merge } from 'lodash';
import { Model, Sequelize } from 'sequelize';
import sequelize from '../lib/db';

class Fill extends Model {
  toJSON () {
    const origin = {
      id: this.id,
      user_id: this.user_id,
      survey_id: this.survey_id,
      detail: this.detail,
      quiz_time: this.quiz_time,
      create_time: this.create_time
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
    user_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '用户id'
    },
    survey_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '问卷id'
    },
    detail: {
      type: Sequelize.JSON,
      allowNull: false,
      comment: '收集的详情'
    },
    quiz_time: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '答题时间（秒）'
    },
    create_time: {
      type: Sequelize.DATE
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
        fields: ['survey_id', 'user_id']
      }]
    },
    InfoCrudMixin.options
  )
);

export { Fill as FillModel };
