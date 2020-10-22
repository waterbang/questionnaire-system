import { HttpException, config } from 'lin-mizar';

const CodeMessage = config.getItem('codeMessage', {});

/**
 * 自定义异常类
 */
class BookNotFound extends HttpException {
  constructor (ex) {
    super();
    this.status = 404;
    this.code = 10022;
    this.message = CodeMessage.getMessage(10022);
    this.exceptionHandler(ex);
  }
}

class SurveyStatusReleased extends HttpException {
  constructor (ex) {
    super();
    this.status = 304;
    this.code = 10261;
    this.message = CodeMessage.getMessage(10261);
    this.exceptionHandler(ex);
  }
}

class SurveyNotRelease extends HttpException {
  constructor (ex) {
    super();
    this.status = 403;
    this.code = 10262;
    this.message = CodeMessage.getMessage(10262);
    this.exceptionHandler(ex);
  }
}

export { BookNotFound, SurveyStatusReleased, SurveyNotRelease };
