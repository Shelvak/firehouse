class Ability
  include CanCan::Ability

  intervention_subclasses = [
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
    user ? user_rules(user) : nil
  end

  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules", user) if respond_to?("#{role}_rules")
    end
  end

  def admin_rules(user)
    can :manage, :all
    cannot [:brightness, :volume], Light
  end

  def radio_rules(user)
    can :manage, intervention_subclasses
    can [:destroy, :update], intervention_subclasses do |instance|
      instance.created_at <= MAX_PERMITTED_HANDLE_DAYS.days.ago
    end
    can :activate, Sco
    can [:map, :special_sign, :create, :update, :read], Intervention
    can :read, [
      Sco, InterventionType, Firefighter, Truck
    ]
    can [:edit_profile, :update_profile], User, id: user.id
    can do |action, subject_class, subject|
      action.match(/autocomplete_for_(\w+)_name/)
    end

    can :read, Shift, user_id: user.id
    can :create, Shift
    can :update, Shift do |shift|
      shift.user_id == user.id && shift.created_at <= 2.days.ago
    end
  end

  def firefighter_rules(user)
    radio_rules(user)
  end

  def subofficer_rules(user)
    firefighter_rules(user)

    can :update, intervention_subclasses
  end

  def reporter_roles(user)
    firefighter_rules(user)

    can [:read, :reports], Shift
  end

  def shifts_admin_roles(user)
    firefighter_rules(user)

    can :manage, Shift
  end

  def officer_roles(user)
    firefighter_rules(user)

    can :manage, intervention_subclasses + [Intervention]
  end

  def intervention_admin_roles(user)
    officer_roles(user)

    can :manage, [
      Firefighter, Sco, Hierarchy, Truck, InterventionType, User
    ]
  end

  def bosses_roles(user)
    intervention_admin_roles(user)

    can :manage, Shift
    cannot [:brightness, :volume], Light
  end

  def sysadmin_roles(user)
    can :manage, :all
  end
end
