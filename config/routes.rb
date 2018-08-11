Rails.application.routes.draw do

  get :console, to: 'websockets#console'
  get :console_create, to: 'interventions#console_create'

  resources :call_center, only: [:index], constraints: { id: /.*/ } do
    get :download, on: :member
  end

  resources :interventions do
    collection do
      ['firefighter', 'receptor', 'sco'].each do |obj|
        get :"autocomplete_for_#{obj}_name"
      end
      get :autocomplete_for_truck_number
      get :map
    end

    put :special_sign, on: :member


    resources :endowments do
      resource :mobile_intervention, on: :member do
        resources :buildings, except: [:index, :show] do
          resources :people, except: [:index, :show]
        end
        resources :supports, except: [:index, :show]
        resources :vehicles, except: [:index, :show] do
          resources :people, except: [:index, :show]
        end
        resources :people, except: [:index, :show]
      end
    end
  end

  resources :vehicles, :buildings, only: [:show] do
    resources :insurances, only: [:show, :new, :create, :edit, :update, :destroy]
  end

  devise_for :users

  resources :users do
    collection do
      get :autocomplete_for_user_name
    end
    member do
      get :edit_profile
      patch :update_profile
    end
  end

  match '/fullscreen' => 'tracking_maps#fullscreen', as: :fullscreen, via: :get

  root to: 'interventions#new'

  get 'private/:path' => 'files#download', constraints: { path: /.+/ }

  namespace :configs do
    resources :intervention_types, except: :show do
      collection do
        get :lights_priorities
        get :priorities
        get :edit_priorities
        put :set_priority
        put :clean_light_priorities
      end
      member do
        put :lights_priority
      end
    end
    resources :firefighters do
      resources :dockets, on: :member
      resources :relatives, except: :show
    end
    resources :trucks, :users
    resources :hierarchies do
      get :autocomplete_for_hierarchy_name, on: :collection
    end
    resources :scos do
      put :activate, on: :member
      put :desactivate, on: :member
    end

    resources :shifts do
      get :reports, on: :collection
    end

    match 'lights/brightness', to: 'lights#brightness', via: [:patch, :get]
    patch 'lights/volume', to: 'lights#volume'
  end
end
