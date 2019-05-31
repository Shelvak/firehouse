module InterventionsHelper
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

  def intervention_types_collection(hide_priority: true)
    intervention_types.order_by_children.map do |it|
      emergency_class = if hide_priority && it.priority
                          'hidden'
                        elsif it.emergency?
                          'alert alert-danger'
                        else
                          ''
                        end
      [it.to_s, it.id, { class: emergency_class }]
    end
  end

  def intervention_type_select(form)
    form.input :intervention_type_id,
      collection: intervention_types_collection(hide_priority: form.object.new_record?),
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
        trap:  {
          url: 'trap_button.png',
          disappear: true
        }
      })
    end

    unless @intervention.try(:electric_risk?)
      buttons.merge!({
        electric_risk:  {
          url: 'electric_risk_button.png',
          disappear: true
        }
      })
    end

    unless @intervention.try(:endowment_out?)
      buttons.merge!({
        qta: {
          url: 'qta_button.png',
          disappear: true,
        }
      })
    end

    buttons
  end

  def intervention_path_with_params(hash)
    hash[:interval] ||= params[:interval]
    hash[:page]     ||= params[:page]
    hash[:type]     ||= params[:type]
    hash[:user]     ||= params[:user]

    interventions_path(hash.compact)
  end

  def filters_header
      return unless [params[:user], params[:interval], params[:type]].any? {|e| e.present? }

      filtered = content_tag(:h3, 'Filtrado por:')
      filtered << content_tag(:h4, "- Usuario: #{User.find(params[:user])}") if params[:user]
      filtered << content_tag(:h4, "- Tipo: #{InterventionType.find(params[:type])}") if params[:type]
      filtered << content_tag(:h4, "- Rango: [#{l @from, format: :minimal} => #{l @to, format: :minimal}] ") if params[:interval]
      filtered
  end
end
