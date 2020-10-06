import { Sequelize, Model } from 'sequelize';
import sequelize from '../lib/db';

class UserSurvey extends Model {};

UserSurvey.init(
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
    user_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '用户id'
    }
  },
  {
    sequelize,
    timestamps: false,
    tableName: 'lin_user_survey',
    modelName: 'user_survey',
    indexes: [
      {
        name: 'user_id_survey_id',
        using: 'BTREE',
        fields: ['user_id', 'survey_id']
      }
    ]
  }
);

export { UserSurvey as UserSurveyModel };