import { LinRouter, NotFound, disableLoading } from 'lin-mizar';
import { loginRequired } from '../../middleware/jwt';
import { CreateOrUpdateSurveyValidator, UpdateSurveyStatusValidator, FillSurveyValidator } from '../../validator/survey';
import { PaginateValidator, PositiveIdValidator } from '../../validator/common';
import { logger } from '../../middleware/logger';
import { getSafeParamId } from '../../lib/util';
import { SurveyDao } from '../../dao/survey';
import { SurveyStatusReleased } from '../../lib/exception';
import { statusRelease } from '../../config/setting';

console.log(disableLoading);

const surveyApi = new LinRouter({
  prefix: '/v1/survey',
  module: '问卷'
});

const surveyDto = new SurveyDao();

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
    if (!rows || rows.length < 1) {
      throw new NotFound({
        code: 10260
      });
    }
    ctx.json({
      total: total,
      items: rows,
      page: v.get('query.page'),
      count: v.get('query.count')
    });
  }
);

// 创建问卷
surveyApi.post('/', async ctx => {
  const v = await new CreateOrUpdateSurveyValidator().validate(ctx);
  await surveyDto.createSurvey(v);
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
    await surveyDto.fillSurvey(v);
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

module.exports = { surveyApi, [disableLoading]: false };