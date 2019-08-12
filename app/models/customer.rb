class Customer
    
    include HTTParty
    
    base_uri "http://localhost:8081"
    format :json
  
 
    def Customer.updateCustomerOrder(order)
        puts "in customer.rb - customer id is "
        puts order[:custId]
        
        response = put "/customers/update/#{order[:custId]}",
        body: order.to_json,
        headers: {"CONTENT_TYPE" => "application/json"}
        return response.code
    end
    
    def Customer.createCustomer(customer)
        post '/customers', body: customer.to_json, headers: {'Content-Type'=>'application/json', 'ACCEPT'=>'application/json'}
    end
    
      
    def Customer.getCustomerByEmail(email)
        response = get "/customers?email=#{email}"
        return response
    end
    
    def Customer.getCustomerById(id)
       response = get "/customers?id=#{id}" 
       #status = response.code
       # customer = JSON.parse response.body #, symbolize_names: true
        return response #customer#status, customer
    end

end