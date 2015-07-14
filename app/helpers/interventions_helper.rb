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

      collection << [name, it.id]
    end

    form.input :intervention_type_id, collection: collection,
      input_html: { selected: form.object.try(:intervention_type_id), data: { intervention_saver: true } }
  end

  def special_intervention_buttons
    {
      trap:  { url: 'trap_button.png'  },
      alert: { url: 'alert_button.png' },
      fake:  { url: 'fake_button.png'  }
    }
  end
end
