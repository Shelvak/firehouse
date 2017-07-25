module DocketsHelper

  DOCKET_URLS = {
    new:    'new_configs_firefighter_docket_path',
    edit:   'edit_configs_firefighter_docket_path',
    show:   'configs_firefighter_docket_path',
    create: 'configs_firefighter_docket_path',
    delete: 'configs_firefighter_docket_path',
    update: 'configs_firefighter_docket_path',
  }

  def docket_url(docket, action)
    send(DOCKET_URLS[action.to_sym], docket.try(:id), firefighter_id: @firefighter_id || @firefighter.id)
  end
end
