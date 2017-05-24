class Ability
  include CanCan::Ability

  INTERVENTION_SUBCLASSES = [
    MobileIntervention, Endowment, EndowmentLine, Building,
    Informer, Insurance, Person, Relative, Support, Vehicle
  ]

  EXCLUDE_ROLES_FOR = {
    sysadmin: [],
    bosses: [:sysadmin],
    intervention_admin: [:bosses, :sysadmin]
  }

  def self.exclude_roles_for(role=nil)
    EXCLUDE_ROLES_FOR[role] || []
  end

  def initialize(user)
    puts "initialized madafaca"
    user ? user_rules(user) : nil
  end

  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules", user) if respond_to?("#{role}_rules")
    end
  end

  def admin_rules(user)
    puts "Admin rules"
    can :manage, :all
  end

  def radio_rules(user)
    puts "Radio rules"
    can [:create, :read], INTERVENTION_SUBCLASSES
    can [:destroy, :update], INTERVENTION_SUBCLASSES do |instance|
      instance.created_at >= MAX_PERMITTED_HANDLE_DAYS.days.ago
    end
    can :activate, Sco
    can [:map, :special_sign, :create], Intervention
    can [:update, :read], Intervention do |intervention|
      intervention.open?  ||
        intervention.created_at >= MAX_PERMITTED_HANDLE_DAYS.days.ago
    end
    #  Sco, InterventionType, Firefighter, Truck
    #]
    can [
      :autocomplete_for_truck_number, :autocomplete_for_receptor_name,
      :autocomplete_for_sco_name, :autocomplete_for_firefighter_name
    ], Intervention

    can [:edit_profile, :update_profile], User, id: user.id
    can do |action, subject_class, subject|
      action.match(/autocomplete_for_(\w+)_name/)
    end

    # can :create, Shift
    # can :read, Shift do |shift|
    #   shift.firefighter.user_id == user.id
    # end
    # can :update, Shift do |shift|
    #   shift.firefighter.user_id == user.id && shift.created_at >= 2.days.ago
    # end

    can :manage, TrackingMap
  end

  def firefighter_rules(user)
    puts "Firefighter rules"
    radio_rules(user)
    can :destroy, Intervention do |intervention|
      intervention.created_at >= MAX_PERMITTED_HANDLE_DAYS.days.ago
    end
  end

  def subofficer_rules(user)
    puts "Subofficer rules"
    firefighter_rules(user)

    can :update, INTERVENTION_SUBCLASSES
  end

  def reporter_rules(user)
    puts "reporter rules"
    firefighter_rules(user)

    can :read, Intervention
    can [:read, :reports], Shift
  end

  def shifts_admin_rules(user)
    puts "Shift rules"
    firefighter_rules(user)

    can :manage, Shift
    # can :read, User  # check that in the future
  end

  def officer_rules(user)
    puts "officer_rules"
    firefighter_rules(user)

    can :read, Shift
    can :manage, INTERVENTION_SUBCLASSES + [Intervention]
  end

  def intervention_admin_rules(user)
    puts "intervention rules"
    officer_rules(user)

    can :read, Shift
    can :manage, [
      Firefighter, Sco, Hierarchy, Truck, InterventionType, User
    ]
  end

  def bosses_rules(user)
    puts "bosses rules"
    intervention_admin_rules(user)

    can :manage, Shift
    cannot [:brightness, :volume], Light
  end

  def sysadmin_rules(user)
    puts "Sysadmin rules"
    can :manage, :all
  end
end
