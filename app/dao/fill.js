import { FillModel } from '../model/fill';

class FillDao {
  async getFill (id) {
    const fill = await FillModel.findOne({
      where: {
        survey_id: id
      }
    });
    return fill;
  }

  async createFill (id, detail) {
    const fill = new FillModel();
    fill.survey_id = id;
    fill.detail = detail;
    return fill;
  }
}

export { FillDao };