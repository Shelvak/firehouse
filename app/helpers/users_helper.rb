module UsersHelper
  def show_user_roles_options(form)
    roles = User.valid_roles - Ability.exclude_roles_for(current_user.try(:role))

    options = roles.map { |r| [t("view.users.roles.#{r}"), r] }

    form.input :role, collection: options, label: false, prompt: false,
      input_html: { class: nil }
  end
end
