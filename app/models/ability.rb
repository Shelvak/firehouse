class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_rules(user) : nil
  end

  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules") if respond_to?("#{role}_rules")
    end
  end

  def admin_rules
    can :manage, :all
  end

  def firefighter_rules
    can :manage, [
      MobileIntervention, Endowment, EndowmentLine, Building,
      Informer, Insurance, Person, Relative, Support, Vehicle
    ]
    can :activate, Sco
    can :map, Intervention
    can :special_sign, Intervention
    can :create, Intervention
    can :update, Intervention
    can :read, [
      Intervention, Sco, InterventionType, Firefighter, Truck
    ]
    can :edit_profile, User
    can :update_profile, User
    can do |action, subject_class, subject|
      action.match(/autocomplete_for_(\w+)_name/)
    end
  end
end
