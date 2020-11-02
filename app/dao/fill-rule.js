import { FillRuleModel } from '../model/fill-rule';

class FillRuleDao {
  async getFillRules (id) {
    const fillRule = await FillRuleModel.findAll({
      where: {
        survey_id: id
      }
    });
    return fillRule;
  }

  async getFillRuleIps (ip) {
    const fillRule = await FillRuleModel.findAll({
      where: {
        ip
      }
    });
    return fillRule;
  }

  async createFillRule (id, ip, username) {
    const fillRule = new FillRuleModel();
    fillRule.ip = ip;
    fillRule.survey_id = id;
    fillRule.username = username;
    return fillRule;
  }
}

export { FillRuleDao };