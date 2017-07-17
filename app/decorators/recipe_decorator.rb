class RecipeDecorator < Draper::Decorator
  delegate_all

  def prep_time
    if model.prep_time.present?
      model.prep_time
    else
      '記載なし'
    end
  end

  def cook_time
    if model.cook_time.present?
      model.cook_time
    else
      '記載なし'
    end
  end

  def total_time
    if model.total_time.present?
      model.total_time
    else
      '記載なし'
    end
  end

end