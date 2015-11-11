module PeopleHelper
  def people_url_for_form
    new_action = (action_name == 'new' || action_name == 'create')

    case @type.class
      when Vehicle
        if new_action
          intervention_endowment_mobile_intervention_vehicle_people_path
        else
          intervention_endowment_mobile_intervention_vehicle_person_path
        end
      when Building
        if new_action
          intervention_endowment_mobile_intervention_building_people_path
        else
          intervention_endowment_mobile_intervention_building_person_path
        end
      else
        if new_action
          intervention_endowment_mobile_intervention_people_path
        else
          intervention_endowment_mobile_intervention_person_path
        end
    end
  end
end
