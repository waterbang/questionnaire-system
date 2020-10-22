import { LinValidator, Rule } from 'lin-mizar';
import { PositiveIdValidator } from './common';

class CreateOrUpdateSurveyValidator extends LinValidator {
  constructor () {
    super();
    this.title = new Rule('isNotEmpty', '必须传入问卷标题');
    this.detail = new Rule('isNotEmpty', '必须传入问卷内容');
  }
}

class UpdateSurveyStatusValidator extends PositiveIdValidator {
  constructor () {
    super();
    this.status = new Rule('isInt', '分组id必须是整数，且大于0小于3', {
      min: 1,
      max: 2
    });
  }
}

class FillSurveyValidator extends PositiveIdValidator {
  constructor () {
    super();
    this.detail = new Rule('isNotEmpty', '填写详情不能为空');
  }
}

export { CreateOrUpdateSurveyValidator, UpdateSurveyStatusValidator, FillSurveyValidator };