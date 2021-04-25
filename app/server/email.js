// email.js
// 引入 nodemailer
import template from 'art-template';
import { config, generate, NotFound } from 'lin-mizar';
import nodemailer from 'nodemailer';
import { emailHash, emailPass, emailUser } from '../config/setting';
import { EmailDao } from '../dao/email';
const path = require('path');
const emailDao = new EmailDao();

class Email {
  constructor () {
    // 创建一个SMTP客户端配置
    this.config = {
      service: '163',
      port: 465,
      auth: {
        user: emailUser,
        pass: emailPass
      }
    };
    this.transporter = nodemailer.createTransport(this.config);
  }

  async createEmail (user_id, user_email) {
    const code = generate(`${user_id}${emailHash}${Date.now()}`);
    const siteDomain = config.getItem('siteDomain', 'http://localhost');

    const has = await emailDao.getEmailCode(user_id);
    // 如果已经发送过
    if (has) {
      // 看看有没有超过时间
      if (await emailDao.validatorExcode(user_id, has.ex_time)) {
        throw new NotFound({
          code: 10502
        });
      }
    }

    const obj = {
      title: '点击激活账号',
      url: `${siteDomain}/checkCode?code=${code}&user_id=${user_id}`,
      imgUrl: siteDomain
    };
    const html = template(path.resolve(__dirname, '../assets/email/index.html'), obj); // mail_temp.html为你想使用到页面模板,obj为你的参数
    // 创建一个邮件对象
    const mail = {
      // 发件人
      from: '玉米问卷调查系统 <water_bang@163.com>',
      // 主题
      subject: '账号激活🇨🇳',
      // 收件人
      to: user_email,
      // 邮件内容，HTML格式
      html: html
    };
    this.send(mail);
    await emailDao.createRenderCode(user_id, code);
  }

  send (mail) {
    this.transporter.sendMail(mail, function (error, info) {
      if (error) {
        return console.log(error);
      }
      // 存入数据库
      console.log('mail sent:', info.response);
    });
  };
};

export default new Email();
