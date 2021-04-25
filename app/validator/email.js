import { LinValidator, Rule } from 'lin-mizar';
/**
 * 验证邮箱
 */
class liveEmailValidator extends LinValidator {
  constructor () {
    super();
    this.email = [
      new Rule('isEmail', '电子邮箱不符合规范，请输入正确的邮箱')
    ];
  }
}
class ActivateEmailValidator extends LinValidator {
  constructor () {
    super();
    this.code = new Rule('isNotEmpty', '必须传入验证密钥');
    this.user_id = new Rule('isNotEmpty', '必须传入用户id');
  }
}

export { liveEmailValidator, ActivateEmailValidator };
