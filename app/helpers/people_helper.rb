module PeopleHelper
  def people_url_for_form
    new_action = (action_name == 'new' || action_name == 'create')

    if @vehicle
      if new_action
        intervention_endowment_mobile_intervention_vehicle_people_path
      else
        intervention_endowment_mobile_intervention_vehicle_person_path
      end
    else @building
      if new_action
        intervention_endowment_mobile_intervention_building_people_path
      else
        intervention_endowment_mobile_intervention_building_person_path
      end
    end
  end
end
