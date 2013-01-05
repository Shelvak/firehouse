Firehouse::Application.routes.draw do
  resources :trucks

  resources :interventions do
    get :autocomplete_for_truck_number, on: :collection
  end

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
