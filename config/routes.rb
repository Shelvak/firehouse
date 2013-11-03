Firehouse::Application.routes.draw do

  resources :firefighters, :trucks

  resources :interventions do
    collection do
      ['firefighter', 'receptor', 'sco'].each do |obj|
        get :"autocomplete_for_#{obj}_name"
      end
      get :autocomplete_for_truck_number
      get :map
    end

    resources :endowments do
      resource :mobile_intervention, on: :member do
        resources :buildings, except: [:index, :show] do
          resources :people, except: [:index, :show]
        end
        resources :supports, except: [:index, :show]
        resources :vehicles, except: [:index, :show] do
          resources :people, except: [:index, :show]
        end
      end
    end
  end

  devise_for :users
  
  resources :users do
    get :autocomplete_for_hierarchy_name, on: :collection
    member do
      get :edit_profile
      put :update_profile
    end
  end

  match '/fullscreen' => 'tracking_maps#fullscreen', as: :fullscreen, via: :get

  root to: redirect('/users/sign_in')

  namespace :configs do
    resources :intervention_types, except: :show do
      collection do
        get :priorities
        get :edit_priorities
        put :set_priority
      end
    end
    resources :hierarchies
    resources :scos do
      put :activate, on: :member
      get :mini_index, on: :collection
    end
  end
end
