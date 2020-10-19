import { NotFound, Forbidden } from 'lin-mizar';
import { Survey } from '../model/survey';
import { Rule } from '../model/rule';
import { set } from 'lodash';
import sequelize from '../lib/db';

Survey.hasOne(Rule, { foreignKey: 'survey_id' });

class SurveyDao {
  async getSurvey (id) {
    const survey = await Survey.findOne({
      where: {
        id
      }
    });
    const rule = await Rule.findOne({
      where: {
        survey_id: id
      },
      attributes: ['detail_rule']
    });
    set(survey, 'detail_rule', rule)
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
          attributes: ['detail_rule']
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
      ru.detail_rule = v.get('body.rule');
      await ru.save({ transaction });

      await transaction.commit();
    } catch (err) {
      if (transaction) await transaction.rollback();
    }
    return true;
  }

  async updateSurvey (v, id) {
    const survey = await Survey.findByPk(id);
    if (!survey) {
      throw new NotFound({
        code: 10022
      });
    }
    survey.title = v.get('body.title');
    survey.header_desc = v.get('body.header_desc');
    survey.footer_desc = v.get('body.footer_desc');
    survey.detail = v.get('body.detail');
    await survey.save();
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
    const survey = await Survey.findByPk(id);
    if (!survey) {
      throw new NotFound({
        code: 10022
      });
    }
    const status = v.get('body.status');
    survey.status = status;
    await survey.save();
  }

  async deleteSurvey (id) {
    const survey = await Survey.findOne({
      where: {
        id
      }
    });
    if (!survey) {
      throw new NotFound({
        code: 10022
      });
    }
    survey.destroy();
  }
}

export { SurveyDao };