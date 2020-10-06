import { LinRouter, NotFound, disableLoading } from 'lin-mizar';
import { groupRequired, loginRequired } from '../../middleware/jwt';
import { CreateOrUpdateSurveyValidator } from '../../validator/survey';
import { PaginateValidator, PositiveIdValidator } from '../../validator/common';
import { logger } from '../../middleware/logger';
import { getSafeParamId } from '../../lib/util';
import { SurveyDao } from '../../dao/survey';
import { SurveyNotFound } from '../../lib/exception';

console.log(disableLoading);

const surveyApi = new LinRouter({
  prefix: '/v1/survey',
  module: '问卷'
});

const surveyDto = new SurveyDao();

surveyApi.get('/:id', async ctx => {
  const v = await new PositiveIdValidator().validate(ctx);
  const id = v.get('path.id');
  const survey = await surveyDto.getSurvey(id);
  if (!survey) {
    throw new NotFound({
      code: 10022
    });
  }
  ctx.json(survey);
});

surveyApi.linGet(
  'getSurveys',
  '/',
  loginRequired,
  async ctx => {
    const v = await new PaginateValidator().validate(ctx);
    const { rows, total } = await surveyDto.getSurveys(v);
    if (!rows || rows.length < 1) {
      throw new SurveyNotFound({
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

surveyApi.post('/', async ctx => {
  const v = await new CreateOrUpdateSurveyValidator().validate(ctx);
  await surveyDto.createSurvey(v);
  ctx.success({
    code: 12
  });
});

surveyApi.put('/:id', async ctx => {
  const v = await new CreateOrUpdateSurveyValidator().validate(ctx);
  const id = getSafeParamId(ctx);
  await surveyDto.updateSurvey(v, id);
  ctx.success({
    code: 13
  });
});

surveyApi.linDelete(
  'deleteSurvey',
  '/:id',
  surveyApi.permission('删除问卷'),
  groupRequired,
  logger('{user.username}就是皮了一波'),
  async ctx => {
    const v = await new PositiveIdValidator().validate(ctx);
    const id = v.get('path.id');
    await surveyDto.deleteSurvey(id);
    ctx.success({
      code: 14
    });
  });

module.exports = { surveyApi, [disableLoading]: false };