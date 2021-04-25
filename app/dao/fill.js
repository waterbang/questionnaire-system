import { Op } from 'sequelize';
import sequelize from '../lib/db';
import { FillModel } from '../model/fill';
import { SurveyRuleServer } from '../server/survey-rule';
import { FillRuleDao } from './fill-rule';
import { RuleDao } from './rule';

const ruleDao = new RuleDao();
const fillRuleDao = new FillRuleDao();
class FillDao {
  async getFill (id) {
    const fill = await FillModel.findOne({
      where: {
        survey_id: id
      }
    });
    return fill;
  }

  async getFills (id) {
    const fill = await FillModel.findAll({
      where: {
        survey_id: id
      }
    });
    return fill;
  }

  async createFill (id, quiz_time, detail, user_id) {
    const fill = new FillModel();
    fill.user_id = user_id || null;
    fill.survey_id = id;
    fill.detail = detail;
    fill.quiz_time = quiz_time;
    return fill;
  }

  async fillSurvey (v, ip) {
    const id = v.get('path.id');
    const detail = v.get('body.detail');
    const username = v.get('body.username');
    const quiz_time = v.get('body.quiz_time');
    const rule = await ruleDao.getRule(id);
    const fillRules = await fillRuleDao.getFillRules(id);
    await new SurveyRuleServer(fillRules, rule, username, ip);
    let transaction;
    try {
      transaction = await sequelize.transaction();
      const fillRule = await fillRuleDao.createFillRule(id, ip, username);
      await fillRule.save({ transaction });

      const fill = await this.createFill(id, quiz_time, detail, v.get('body.user_id'));
      await fill.save({ transaction });
      await transaction.commit();
    } catch (err) {
      console.log(err);
      if (transaction) await transaction.rollback();
    }
  }

  async getFillInfos (ctx) {
    const FillNums = await FillModel.count({
      where: {
        user_id: ctx.currentUser.id
      }
    });
    const n = await FillModel.count({
      where: {
        create_time: {
          [Op.lt]: new Date(),
          [Op.gt]: new Date(new Date() - 30 * 24 * 60 * 60 * 1000)
        }
      }
    });
    return {
      userFillNums: FillNums,
      userMonthFill: n
    };
  }
}

export { FillDao };
