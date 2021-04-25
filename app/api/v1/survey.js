import { disableLoading, LinRouter } from 'lin-mizar';
import { statusEstablish, statusRelease } from '../../config/setting';
import { FillDao } from '../../dao/fill';
import { SurveyDao } from '../../dao/survey';
import { SurveyNotRelease, SurveyStatusReleased } from '../../lib/exception';
import { getSafeParamId } from '../../lib/util';
import { loginRequired } from '../../middleware/jwt';
import { logger } from '../../middleware/logger';
import { PaginateValidator, PositiveIdValidator } from '../../validator/common';
import { CreateOrUpdateSurveyValidator, FillSurveyValidator, UpdateSurveyStatusValidator } from '../../validator/survey';

console.log(disableLoading);

const surveyApi = new LinRouter({
  prefix: '/v1/survey',
  module: '问卷'
});

const surveyDto = new SurveyDao();
const fillDao = new FillDao();

// 获取单个问卷
surveyApi.get('/:id', async ctx => {
  const v = await new PositiveIdValidator().validate(ctx);
  const id = v.get('path.id');
  const survey = await surveyDto.getSurvey(id);
  ctx.json(survey);
});

// 获取全部问卷（分页）
surveyApi.linGet(
  'getSurveys',
  '/',
  loginRequired,
  async ctx => {
    const v = await new PaginateValidator().validate(ctx);
    const { rows, total } = await surveyDto.getSurveys(v);
    ctx.json({
      total: total,
      items: rows,
      page: v.get('query.page'),
      count: v.get('query.count')
    });
  }
);

// 创建问卷
surveyApi.linPost(
  'createSurvey',
  '/',
  loginRequired,
  async ctx => {
    const v = await new CreateOrUpdateSurveyValidator().validate(ctx);
    await surveyDto.createSurvey(v, ctx);
    ctx.success({
      code: 12
    });
  });

// 更新问卷
surveyApi.put('/:id', async ctx => {
  const v = await new CreateOrUpdateSurveyValidator().validate(ctx);
  const id = getSafeParamId(ctx);
  await surveyDto.updateSurvey(v, id);
  ctx.success({
    code: 13
  });
});

// 更新问卷状态
surveyApi.linPut(
  'updateSurveyStatus',
  '/update/status/:id',
  surveyApi.permission('发布问卷'),
  loginRequired,
  logger('{user.username} 发布了id为 {request.body.id} 的问卷'),
  async ctx => {
    const v = await new UpdateSurveyStatusValidator().validate(ctx);
    const id = getSafeParamId(ctx);
    const status = await surveyDto.getSurveyStatus(id);
    if (status === statusRelease) { // 如果已发布
      throw new SurveyStatusReleased();
    }
    await surveyDto.updateSurveyStatus(v, id);
    return ctx.success({
      code: 16
    });
  }
);

// 收集问卷
surveyApi.linPost(
  'fillSurvey',
  '/fill/:id',
  async ctx => {
    const v = await new FillSurveyValidator().validate(ctx);
    const status = await surveyDto.getSurveyStatus(v.get('path.id'));
    if (status === statusEstablish) { // 如果未发布
      throw new SurveyNotRelease();
    }
    await fillDao.fillSurvey(v, ctx.request.ip);
    return ctx.success({
      code: 17
    });
  });

// 删除问卷
surveyApi.linDelete(
  'deleteSurvey',
  '/:id',
  surveyApi.permission('删除问卷'),
  loginRequired,
  logger('{user.username}删除了id为 {request.path} 的问卷'),
  async ctx => {
    const v = await new PositiveIdValidator().validate(ctx);
    const id = v.get('path.id');
    await surveyDto.deleteSurvey(id);
    ctx.success({
      code: 14
    });
  });

// 获取统计信息
surveyApi.linGet(
  'gatherInfo',
  '/gather/:id',
  surveyApi.permission('查看问卷统计信息'),
  loginRequired,
  async ctx => {
    const v = await new PositiveIdValidator().validate(ctx);
    const id = v.get('path.id');
    const fills = await fillDao.getFills(id);
    ctx.json(fills);
  }
);

// ---------获取数据统计信息
// 获取上上个月，上个月，下个月的问卷数量
surveyApi.linGet(
  'getAnalyseMonth',
  '/analyse/month',
  surveyApi.permission('查看数据分析'),
  loginRequired,
  async ctx => {
  }
);

module.exports = { surveyApi, [disableLoading]: false };