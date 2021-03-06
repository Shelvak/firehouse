module ShiftsHelper

  def _get_translation_for_kind(kind)
    I18n.t('view.shifts.kinds.' + kind)
  end

  def show_shift_kind(kind)
    _get_translation_for_kind Shift::KINDS[kind]
  end

  def select_kind_for_shift(form)
    collection = Shift::KINDS.map do |i, kind|
      [_get_translation_for_kind(kind), i]
    end

    form.input :kind, collection: collection, value: form.object.kind
  end
end
