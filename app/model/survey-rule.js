import { Model, Sequelize } from 'sequelize';
import sequelize from '../lib/db';

class SurveyRule extends Model {}

SurveyRule.init(
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
    rule_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      comment: '问卷规则id'
    }
  },
  {
    sequelize,
    timestamps: false,
    tableName: 'lin_survey_rule',
    modelName: 'survey_rule',
    indexes: [
      {
        name: 'survey_id_rule_id',
        using: 'BTREE',
        fields: ['survey_id', 'rule_id']
      }
    ]
  }
);

export { SurveyRule as SurveyRuleModel };
