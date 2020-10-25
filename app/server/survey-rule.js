import { HttpException, config } from 'lin-mizar';

const CodeMessage = config.getItem('codeMessage', {});

class SurveyRule {
  constructor (fills, rule, username, ip) {
    this.validator(fills, rule, username, ip);
  }

  validator (fills, rule, username, ip) {
    if (fills.length === 0) return true;
    if (rule.is_login) { // 如果需要登录
      if (!username) {
        throw new FillNeetLogin();
      }
    }
    if (rule.limit_ip === 0) return true; // 没有开启限制，直接返回
    const ipArr = fills.filter(item => {
      return item.ip === ip;
    });
    if (ipArr.length >= rule.limit_ip) { // 如果填写的ip超过限制IP
      throw new FilllimitimgIp();
    }
    return true;
  }
}

class FillNeetLogin extends HttpException {
  constructor (ex) {
    super();
    this.status = 401;
    this.code = 10301;
    this.message = CodeMessage.getMessage(10301);
    this.exceptionHandler(ex);
  }
}

class FilllimitimgIp extends HttpException {
  constructor (ex) {
    super();
    this.status = 403;
    this.code = 10302;
    this.message = CodeMessage.getMessage(10302);
    this.exceptionHandler(ex);
  }
}

export { SurveyRule as SurveyRuleServer };