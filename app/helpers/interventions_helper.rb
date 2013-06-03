module InterventionsHelper
  def current_sco
    Sco.current
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
    #key = Intervention::KINDS.invert[kind]
    #t("view.interventions.kinds.#{key}")
    InterventionType.find(kind).name
  end

  def show_charge_name(key)
    charge = EndowmentLine::CHARGES[key]
    content_tag(:strong, t("view.interventions.endowments_charges.#{charge}"))
  end
end
