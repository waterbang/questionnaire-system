import { NotFound } from 'lin-mizar';
import { Rule } from '../model/rule';

class RuleDao {
  async getRule (id) {
    const rule = await Rule.findOne({
      where: {
        survey_id: id
      },
      attributes: ['is_copy', 'is_login', 'limit_ip']
    });
    if (!rule) {
      throw new NotFound({
        code: 10401
      });
    }
    return rule;
  }
}

export { RuleDao };