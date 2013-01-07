module InterventionsHelper
  def current_sco
    Sco.current
  end

  def link_to_current_sco
    link_to current_sco, sco_path(current_sco) if current_sco
  end

  def intervention_next_number_for_form
    (Intervention.order(:number).last.try(:number) || 0) + 1
  end

  def kind_collection_for_intervention(form)
    collection = Intervention::KINDS.map do |key, value|
      [t("view.interventions.kinds.#{key}"), value]
    end

    form.input :kind, collection: collection, 
      selected: form.object.kind, prompt: true, as: :radio_buttons,
      input_html: { class: '' }
  end

  def show_kind_of_intervention(kind)
    key = Intervention::KINDS.invert[kind]
    t("view.interventions.kinds.#{key}")
  end
end
