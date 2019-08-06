Rails.application.routes.draw do
    
    #get('status' => 'status#index')
    #resources :customers
    post '/orders' => 'orders#create'
    get '/orders/:id' => 'orders#getOrderById'
    
    #root :to => redirect('/customers')
    #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end