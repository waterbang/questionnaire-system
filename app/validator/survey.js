import { LinValidator, Rule } from 'lin-mizar';

class CreateOrUpdateSurveyValidator extends LinValidator {
  constructor () {
    super();
    this.title = new Rule('isNotEmpty', '必须传入问卷标题');
    this.status = new Rule('isNotEmpty', '必须传入问卷状态');
    this.detail = new Rule('isNotEmpty', '必须传入问卷内容');
  }
}

export { CreateOrUpdateSurveyValidator };