module InterventionsHelper
  def current_sco
    Sco.current
  end

  def intervention_next_number_for_form
    (Intervention.order(:number).last.try(:number) || 0) + 1
  end

  def show_charge_name(key)
    charge = EndowmentLine::CHARGES[key]
    content_tag(:strong, t("view.interventions.endowments_charges.#{charge}"))
  end
end
