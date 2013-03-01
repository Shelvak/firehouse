module InterventionsHelper
  def current_sco
    Sco.current
  end

  def link_to_current_sco
    link_title = current_sco ? current_sco : t('view.interventions.select_sco')
    link_to link_title, mini_index_scos_path, id: 'sco_name', data: {
      toggle: 'modal', 'modal-remote' => true 
    }
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
