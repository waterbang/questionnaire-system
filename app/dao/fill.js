import { SurveyRuleServer } from '../server/survey-rule';
import { FillModel } from '../model/fill';
import { RuleDao } from './rule';
import { FillRuleDao } from './fill-rule';
import sequelize from '../lib/db';

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

  async createFill (id, detail) {
    const fill = new FillModel();
    fill.survey_id = id;
    fill.detail = detail;
    return fill;
  }

  async fillSurvey (v, ip) {
    const id = v.get('path.id');
    const detail = v.get('body.detail');
    const username = v.get('body.username');
    const rule = await ruleDao.getRule(id);
    const fillRules = await fillRuleDao.getFillRules(id);
    await new SurveyRuleServer(fillRules, rule, username, ip);
    let transaction;
    try {
      transaction = await sequelize.transaction();
      const fillRule = await fillRuleDao.createFillRule(id, ip, username);
      await fillRule.save({ transaction });

      const fill = await this.createFill(id, detail);
      await fill.save({ transaction });
      await transaction.commit();
    } catch (err) {
      console.log(err);
      if (transaction) await transaction.rollback();
    }
  }
}

export { FillDao };