import { NotFound, Forbidden } from 'lin-mizar';
import { Survey } from '../model/survey';
import { Rule } from '../model/rule';
import { RuleDao } from './rule';

import { set } from 'lodash';
import sequelize from '../lib/db';

Survey.hasOne(Rule, { foreignKey: 'survey_id' }); // 一对一
const ruleDao = new RuleDao();

class SurveyDao {
  async validatorSurvey (id) {
    const survey = await Survey.findByPk(id);
    if (!survey) {
      throw new NotFound({
        code: 10022
      });
    }
    return survey;
  }

  async getSurvey (id) {
    const survey = await this.validatorSurvey(id);
    const rule = await ruleDao.getRule(id);
    set(survey, 'detail_rule', rule);
    return survey;
  }

  async getSurveys (v) {
    const start = v.get('query.page');
    const count1 = v.get('query.count');
    const { rows, count } = await Survey.findAndCountAll({
      offset: start * count1,
      limit: count1,
      order: [['create_time', 'DESC']],
      include: [
        { model: Rule,
          attributes: ['is_copy', 'is_login', 'limit_ip']
        }
      ]
    });
    return {
      rows,
      total: count
    };
  }

  async createSurvey (v) {
    const survey = await Survey.findOne({
      where: {
        title: v.get('body.title')
      }
    });
    if (survey) {
      throw new Forbidden({
        code: 10240
      });
    }
    let transaction;
    try {
      transaction = await sequelize.transaction();
      const sy = new Survey();
      sy.title = v.get('body.title');
      sy.header_desc = v.get('body.header_desc');
      sy.footer_desc = v.get('body.footer_desc');
      sy.detail = v.get('body.detail');
      await sy.save({ transaction });
      const ru = new Rule();
      ru.survey_id = sy.id;
      ru.is_copy = v.get('body.detail_rule.is_copy') || false;
      ru.is_login = v.get('body.detail_rule.is_login') || false;
      ru.limit_ip = v.get('body.detail_rule.limit_ip') || 1;
      await ru.save({ transaction });

      await transaction.commit();
    } catch (err) {
      if (transaction) await transaction.rollback();
    }
  }

  async updateSurvey (v, id) {
    let transaction;
    try {
      transaction = await sequelize.transaction();
      const sy = await this.validatorSurvey(id);
      sy.title = v.get('body.title');
      sy.header_desc = v.get('body.header_desc');
      sy.footer_desc = v.get('body.footer_desc');
      sy.detail = v.get('body.detail');
      await sy.save({ transaction });

      const ru = await ruleDao.getUpRule(id);
      ru.is_copy = v.get('body.detail_rule.is_copy');
      ru.is_login = v.get('body.detail_rule.is_login');
      ru.limit_ip = v.get('body.detail_rule.limit_ip');
      await ru.save({ transaction });

      await transaction.commit();
    } catch (err) {
      console.log(err)
      if (transaction) await transaction.rollback();
    }
  }

  async getSurveyStatus (id) {
    const survey = await Survey.findOne({
      where: {
        id: id
      },
      attributes: ['status']
    });
    if (!survey) {
      throw new NotFound({
        code: 10022
      });
    }
    return survey.status;
  }

  async updateSurveyStatus (v, id) {
    const survey = await this.validatorSurvey(id);
    const status = v.get('body.status');
    survey.status = status;
    await survey.save();
  }

  async deleteSurvey (id) {
    await this.validatorSurvey(id);
    let transaction;
    try {
      transaction = await sequelize.transaction();
      await Survey.destroy({
        where: {
          id
        },
        transaction
      });
      await Rule.destroy({
        where: {
          id
        },
        transaction
      });
      await transaction.commit();
    } catch (err) {
      if (transaction) await transaction.rollback();
    }
  }
}

export { SurveyDao };