Firehouse::Application.routes.draw do
  resources :hierarchies, :trucks

  resources :scos do
    put :activate, on: :member
  end

  resources :interventions do
    get :autocomplete_for_truck_number, on: :collection
    member do
      put :update_arrive
      put :update_back
      put :update_in
    end
    resources :mobile_interventions do
      resources :buildings do
        resources :people
      end
      resources :supports, only: [:new, :edit, :destroy, :create, :update]
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
end
