Firehouse::Application.routes.draw do

  resources :firefighters, :hierarchies, :trucks

  resources :scos do
    put :activate, on: :member
    get :mini_index, on: :collection
  end

  resources :interventions do
    collection do
      ['firefighter', 'receptor', 'sco'].each do |obj|
        get :"autocomplete_for_#{obj}_name"
      end
      get :autocomplete_for_truck_number
    end

    resources :endowments do
      resource :mobile_intervention, on: :member do
        resources :buildings do
          resources :people
        end
        resources :supports, except: [:index, :show]
        resources :vehicles, except: [:index, :show] do
          resources :people
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


  root to: redirect('/users/sign_in')

  namespace :configs do
    resources :intervention_types do
      collection do
        get :priorities
        get :edit_priorities
        put :set_priority
      end
    end
  end
end
