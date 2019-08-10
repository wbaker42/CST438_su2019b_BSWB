Rails.application.routes.draw do
    
    post '/orders' => 'orders#create'
    get '/orders' => 'orders#getOrder'
    
    post '/customers' =>'orders#regCustomer'
    get '/customers' => 'orders#getCustomer'
    
    post '/items' => 'orders#createItem'
    get "/item/:id" => 'orders#getItemById'

end