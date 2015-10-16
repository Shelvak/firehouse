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
      collection << [it.to_s, it.id, { class: (it.priority ? 'hidden' : '') }]
    end

    form.input :intervention_type_id, collection: collection,
      input_html: {
        selected: form.object.try(:intervention_type_id),
        disabled: form.object.finished?,
        data: { intervention_saver: true }
    }
  end

  def special_intervention_buttons
    buttons = {
      alert: { url: 'alert_button.png' }
    }

    unless @intervention.try(:its_a_trap?)
      buttons.merge!({
        trap:  { url: 'trap_button.png' }
      })
    end

    buttons.merge({
      qta: { url: 'qta_button.png' }
    })
  end
end
