class Customer
    
    include HTTParty
    
    base_uri "http://localhost:8081"
    format :json
  
 
    def Customer.updateCustomerOrder(order)
       # response = put "/customers/update/#{order[:custId]}",
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
            customer = JSON.parse response.body #, symbolize_names: true
        else
            customer = nil
        end
        customer = JSON.parse response.body #, symbolize_names: true
        return code, customer
    end
    
    def Customer.getCustomerById(id)
       response = get "/customers?id=#{id}" 
       #status = response.code
       # customer = JSON.parse response.body #, symbolize_names: true
        return response #customer#status, customer
    end

end