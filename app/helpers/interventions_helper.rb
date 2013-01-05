module InterventionsHelper
  def intervention_next_number_for_form
    (Intervention.order(:number).last.try(:number) || 0) + 1
  end

  def kind_select_for_intervention(form)
    form.input :kind, collection: Intervention::KINDS, 
      selected: form.object.kind, prompt: true
  end

  def show_kind_of_intervention(kind)
    key = Intervention::KINDS.invert[kind]
    t("view.interventions.kinds.#{key}")
  end
end
