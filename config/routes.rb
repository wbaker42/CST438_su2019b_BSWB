Rails.application.routes.draw do
    get('status' => 'status#index')
    resources :customers
    root :to => redirect('/customers')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
