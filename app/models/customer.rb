class Customer
    
    include HTTParty
    
    base_uri "http://localhost:8081"
    format :json
  
 
    def Customer.updateCustomerOrder(order)
        response = put "/customers/order",
        body: order.to_json,
        headers: {"CONTENT_TYPE" => "application/json"}
        return response.code
    end
    def Customer.createCustomer(customer)
        post '/customers', body: customer.to_json, headers: {'Content-Type'=>'application/json', 'ACCEPT'=>'application/json'}
    end
    
      
    def Customer.getCustomerByEmail(email)
        response = get "/customers?email=#{email}"
        code = response.code
        if code !=404
            customer = JSON.parse response.body
        else
            customer = nil
        end
        customer = JSON.parse response.body 
        return code, customer
    end
    
    def Customer.getCustomerById(id)
       response = get "/customers?id=#{id}" 
        return response 
    end

end