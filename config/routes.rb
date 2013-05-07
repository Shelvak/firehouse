Firehouse::Application.routes.draw do

  resources :firefighters, :hierarchies, :trucks

  resources :scos do
    put :activate, on: :member
    get :mini_index, on: :collection
  end

  resources :interventions do
    collection do
      get :autocomplete_for_firefighter_name
      get :autocomplete_for_receptor_name
      get :autocomplete_for_sco_name
      get :autocomplete_for_truck_number
    end
    member do
      put :update_arrive
      put :update_back
      put :update_in
    end
    resources :endowements do
      resources :mobile_interventions
    end
  end
  resources :mobile_interventions do
    resources :buildings do
      resources :people
    end
    resources :supports, only: [:new, :edit, :destroy, :create, :update]
    resources :vehicles, only: [:new, :edit, :destroy, :create, :update] do
      resources :people
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
