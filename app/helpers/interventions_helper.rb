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
    collection = []

    InterventionType.order_by_children.each do |it|
      name = it.name
      name = "-> #{name}" if it.is_a_son?

      collection << [name, it.id, {class: (it.priority ? 'hidden' : '')}]
    end

    form.input :intervention_type_id, collection: collection,
      input_html: {
        selected: form.object.try(:intervention_type_id),
        disabled: form.object.finished?,
        data: { intervention_trigger: 'quick-buttons' }
    }
  end

  def special_intervention_buttons
    buttons = {
      alert: { url: 'alert_button.png' }
    }

    if action_name != 'new'
      buttons.merge!({
        trap:  { url: 'trap_button.png' },
        qta:   { url: 'qta_button.png' }
      })
    end

    buttons
  end
end
