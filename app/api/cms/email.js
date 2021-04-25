import { Forbidden, LinRouter, NotFound } from 'lin-mizar';
import { EmailDao } from '../../dao/email';
import { loginRequired } from '../../middleware/jwt';
import { ActivateEmailValidator } from '../../validator/email';

const emailDao = new EmailDao();

const email = new LinRouter({
  prefix: '/cms/email',
  module: '邮件'
});

email.linGet(
  'isActivate',
  '/isActivate',
  loginRequired,
  async ctx => {
    const user = ctx.currentUser;
    const userEmail = await emailDao.getEmailCode(user.id);
    if (!userEmail) {
      throw new NotFound({
        code: 10504
      });
    }
    ctx.json(userEmail);
  }
);

email.linGet(
  'activate',
  '/activateEmail',
  async ctx => {
    const v = await new ActivateEmailValidator().validate(ctx);
    const code = v.get('query.code');
    const user_id = v.get('query.user_id');
    const userEmail = await emailDao.getEmailCode(user_id);
    if (!userEmail) { //  如果找不到
      throw new NotFound({
        code: 10504
      });
    }
    if (userEmail.islive) { // 验证通过
      ctx.success({
        code: 20
      });
    }
    // 验证看看有没有过期，如果过期就删除账号
    await emailDao.validatorExcode(user_id, userEmail.ex_time);
    if (code !== userEmail.code) {
      throw new Forbidden({
        code: 10503
      });
    }
    // 激活isLive
    await emailDao.activiateEmail(userEmail.id);
    ctx.success({
      code: 20
    });
  }
);

export { email };
