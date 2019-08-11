Rails.application.routes.draw do
    post '/orders' => '#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
    post '/orders' => 'orders#create'
    get '/orders' => 'orders#getOrder'
    
    post '/customers' =>'orders#regCustomer'
    get '/customers' => 'orders#getCustomer'
    
    post '/items' => 'orders#createItem'
    get "/item/:id" => 'orders#getItemById'

end

