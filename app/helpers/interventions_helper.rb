module InterventionsHelper
  def current_sco
    Sco.current
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

  def intervention_types
    InterventionType.all
  end

  def intervention_type_select(form)
    collection = intervention_types.map { |i| [i.name, i.id] }

    form.input :intervention_type_id, collection: collection,
      input_html: { selected: form.object.try(:intervention_type_id) }
  end

  def special_intervention_buttons
    {
      alert: 'alert_button.png',
      trap:  'trap_button.png'
    }
  end
end
