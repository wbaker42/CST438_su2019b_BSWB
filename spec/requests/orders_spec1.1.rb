  require 'rails_helper'
RSpec.describe "Orders", type: :request do
@headers = { "CONTENT_TYPE" => "application/json" , "ACCEPT" => "application/json"}  
=begin    before(:each) do 
        # create database record for Test Dummy

        order = { itemId: 227, 
                email: 'xy@csumb.edu' } 
        headers = {"CONTENT_TYPE" => "application/json" ,
                "ACCEPT" => "application/json"}
                     
        expect(Customer).to receive(:getCustomerByEmail).with('xy@csumb.edu') do
            [ 200, [{'id' => 2, 'award'=> 0 }] ]
        end 
        
        expect(Item).to receive(:getItemById).with(227) do
            [ 200, { 'id'=>227, 'description'=>'makeup',
                      'price'=> 50.00, 'stockQty'=> 100 } ]
        end 
        
        allow(Customer).to receive(:putOrder) do |order|
            expect(order.customerId).to eq 2 
            201
        end 
        
        allow(Item).to receive(:putOrder) do |order|
            expect(order.itemId).to eq 227
            201
        end 
        p order.to_json
        post '/orders', params: order.to_json, headers: headers

=end    end
    describe "POST /orders" do
        it "customer makes purchase" do
          order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
        
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
                     
          expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 200, [{'id' => 1, 'award'=> 0 }] ]
          end 
          
          expect(Item).to receive(:getItemById).with(100) do
            [ 200, { 'id'=>100, 'description'=>'jewelry item',
                          'price'=> 175.00, 'stockQty'=> 2 } ]
          end 
          
          allow(Customer).to receive(:putOrder) do |order|
            expect(order.customerId).to eq 1 
            201
          end 
          
          allow(Item).to receive(:putOrder) do |order|
            expect(order.itemId).to eq 100
            201
          end 
          p order.to_json
          
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(201)
          #order_json = JSON.parse(response)
        end
        
        it "Invalid customer attempts to make a purchase" do
          order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
          expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 204, {'id' => 1, 'award'=> 0 } ]
          end 
          
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(400)        
        end
        it "Valid customer attempts to purchase an invalid item" do
          order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
          expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 200, {'id' => 1, 'award'=> 0 } ]
          end 
          
          expect(Item).to receive(:getItemById).with(100) do
            [ 204, { 'id'=>100, 'description'=>'jewelry item',
                          'price'=> 175.00, 'stockQty'=> 2 } ]
          end 
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(400)        
        end
    end
    
=begin    describe "GET /orders" do
        it "Access order by order ID" do
            get '/orders?id=1', headers: @headers
            json_response = JSON.parse(response.body)
            expect(response).to have_http_status()
    before(:each) do 
        # create database record for Test Dummy
        #Order.create(itemId: "5", customerId:"2")
        
    end
    
    #Create a new customer
    describe "POST /orders" do
        it 'post of new order should return customer information' do
            #headers = { "CONTENT_TYPE" => "application/json" ,
           #        "ACCEPT" => "application/json"}    # Rails 4
            order_new = {itemId: 1, email:"wb@csumb.edu"}
            testItem = double('item')
            allow(testItem).to receive(:itemId) {2}
            allow(testItem).to receive(:description) {"this is a test"}
            allow(testItem).to receive(:price) {100}
            
            testCustomer = double('Customer')
            allow(testCustomer).to receive(:customerId){2}
            allow(testCustomer).to receive(:award){2}
            
            post '/orders', params: order_new.to_json, headers: @headers
            expect(response).to have_http_status(201)
            
            #Make sure the JSON response contains the correct fields
            order = JSON.parse(response.body)
            expect(order.keys).to contain_exactly(
                'id',
                'itemId',
                'description',
                'customerId',
                'price',
                'award',
                'total',
                'created_at',
                'updated_at')
            
           
            #expect(customer['email']).to eq 'williamdotbaker@gmail.com' #Look at screenshot
            #expect(customer['firstName']).to eq 'William'
            #expect(customer['lastName']).to eq 'Baker'
            
            #Check to make sure record was recorded to database
            #customerdb = Customer.find(customer['id'])
            #expect(customerdb['email']).to eq 'williamdotbaker@gmail.com' #look at screenshot
            #expect(customerdb['firstName']).to eq 'William'
            #expect(customerdb['lastName']).to eq 'Baker'
        end
    end
=begin        it 'post of an invalid customer will return an error' do
            customer_new = {email: '', firstName: '', lastName: ''}
            post '/customers', params: customer_new.to_json, headers: headers
            expect(response).to have_http_status(400)
            
            customer_new = {email: 'williamdotbaker@gmail.com', firstName: '', lastName: ''}
            post '/customers', params: customer_new.to_json, headers: headers
            expect(response).to have_http_status(400)
            
            
            customer_new = {email: '', firstName: 'William', lastName: 'Baker'}
            post '/customers', params: customer_new.to_json, headers: headers
            expect(response).to have_http_status(400)
        end
        it 'post of a duplicate customer will return an error' do
            customer_new = {email: 'testdum@yahoo.com', firstName: 'Test', lastName: 'Dummy'}
            post '/customers', params: customer_new.to_json, headers: headers
            expect(response).to have_http_status(400)
        end
    end
    
    describe "GET /customers?email" do
        it 'get customer information for me should return JSON array of length 1 of customer objects' do
            
            headers = { "ACCEPT" => "application/json"}    # Rails 4 
            get '/customers?email=testdum@yahoo.com', headers: headers
            json_response = JSON.parse(response.body)
            expect(response).to have_http_status(200)    
            expect(json_response.length).to eq 1
            customer = json_response[0]
            expect(customer.keys).to contain_exactly(
                'id',
                'email',
                'firstName',
                'lastName',
                'lastOrder',
                'lastOrder2',
                'lastOrder3',
                'award'
                )
            expect(customer['email']).to eq 'testdum@yahoo.com'
            expect(customer['firstName']).to eq 'Test'
            expect(customer['lastName']).to eq 'Dummy'
        end
        it 'get customer information for undefined customer should return JSON array of length 0 and 404 error' do
            headers = { "ACCEPT" => "application/json"}    # Rails 4 
            get '/customers?email=unreal@yahoo.com', headers: headers
            json_response = JSON.parse(response.body)
            expect(json_response.length).to eq 0
            expect(response).to have_http_status(404)  
        end
    end
    describe "GET /customers?id" do
        it 'get customer information for me should return JSON array of length 1 of customer objects' do
            
            headers = { "CONTENT_TYPE" => "application/json" , "ACCEPT" => "application/json"}    # Rails 4 
            get '/customers?id=1', headers: headers
            json_response = JSON.parse(response.body)
            expect(json_response.length).to eq 1
            customer = json_response[0]
            expect(customer.keys).to contain_exactly(
                'id',
                'email',
                'firstName',
                'lastName',
                'lastOrder',
                'lastOrder2',
                'lastOrder3',
                'award'
                )
            expect(customer['id']).to eq 1
            expect(customer['email']).to eq 'testdum@yahoo.com'
            expect(customer['firstName']).to eq 'Test'
            expect(customer['lastName']).to eq 'Dummy'
            expect(response).to have_http_status(200) 
        end
        it 'get customer information for undefined customer should return JSON array of length 0 and 404 error' do
            headers = { "ACCEPT" => "application/json"}    # Rails 4 
            get '/customers?id=1000', headers: headers
            json_response = JSON.parse(response.body)
            expect(json_response.length).to eq 0
            expect(response).to have_http_status(404) 
        end
    end
    
    describe "PUT /customers/order" do
        it 'post of new customer should return customer information' do
            headers = { "CONTENT_TYPE" => "application/json" ,
                   "ACCEPT" => "application/json"}    # Rails 4
            new_customer = {email: 'williamdotbaker@gmail.com', firstName: 'William', lastName: 'Baker'}
            post '/customers', params: new_customer.to_json, headers: headers
            expect(response).to have_http_status(201)
            
            customer = JSON.parse(response.body)
            expect(customer['lastOrder']).to eq nil
            #Create the double for the order class
            
            order1 = double('order')
            allow(order1).to receive(:parameters) {{id: 1, itemId: 123, customerId: 2, price: 200, award: 0, total: 200}}

            put "/customers/order", params: order1.parameters.to_json, headers: headers
            #Make sure the JSON response contains the correct fields

            #customer2 = JSON.parse(response.body)
            expect(response).to have_http_status(204)
            #expect(customer2['lastOrder']).to eq 200
            customerdb = Customer.find(customer['id'])
            expect(customerdb['lastOrder']).to eq 200            
            
        end
        
        it 'does not update invalid customer and returns error' do
            headers = { "CONTENT_TYPE" => "application/json" ,
                   "ACCEPT" => "application/json"}    # Rails 4
            new_customer = {email: 'williamdotbaker@gmail.com', firstName: 'William', lastName: 'Baker'}
            post '/customers', params: new_customer.to_json, headers: headers
            expect(response).to have_http_status(201)
            
            customer = JSON.parse(response.body)
            
            #Create the double for the order class
            
            order1 = double('order')
            allow(order1).to receive(:parameters) {{id: 1, itemId: 123, customerId: 800, price: 200, award: 0, total: 200}}

            put "/customers/order", params: order1.parameters.to_json, headers: headers
            #Make sure the JSON response contains the correct fields
            expect(response).to have_http_status(400)
            
            customerdb = Customer.find(customer['id'])
            expect(customerdb['lastOrder']).to eq customer['lastOrder']            
            
        end
    end
    
    describe "Customer makes 4 consecutive purchases with an award applied on the last one" do
        it "An award is applied on the last order" do
            headers = { "CONTENT_TYPE" => "application/json" ,
                   "ACCEPT" => "application/json"}    # Rails 4
            new_customer = {email: 'williamdotbaker@gmail.com', firstName: 'William', lastName: 'Baker'}
            post '/customers', params: new_customer.to_json, headers: headers
            expect(response).to have_http_status(201)
            
            customer = JSON.parse(response.body)
            expect(customer['lastOrder']).to eq nil
            
            #Create the double for the order class and the first 3 order objects
            order1 = double('order')
            allow(order1).to receive(:parameters) {{id: 1, itemId: 123, customerId: 2, price: 200, award: 0, total: 200}}

            order2 = double('order')
            allow(order2).to receive(:parameters) {{id: 2, itemId: 777, customerId: 2, price: 600, award: 0, total: 600}}
        
            order3 = double('order')
            allow(order3).to receive(:parameters) {{id: 3, itemId: 321, customerId: 2, price: 100, award: 0, total: 100}}
            
            #Begin putting in the orders and test to ensure that 
            put "/customers/order", params: order1.parameters.to_json, headers: headers
            put "/customers/order", params: order2.parameters.to_json, headers: headers
            put "/customers/order", params: order3.parameters.to_json, headers: headers
            
            customerdb = Customer.find(customer['id'])
            
            expect(customerdb['lastOrder']).to eq 200
            expect(customerdb['lastOrder2']).to eq 600
            expect(customerdb['lastOrder3']).to eq 100
            
            expect(customerdb['award']).to eq 30
            
            order4 = double('order')
            allow(order4).to receive(:parameters) {{id: 4, itemId: 421, customerId: 2, price: 250, award: 30, total: 220}}
            put "/customers/order", params: order4.parameters.to_json, headers: headers
            
            customerdb = Customer.find(customer['id'])
            expect(customerdb['lastOrder']).to eq 0
            expect(customerdb['lastOrder2']).to eq 0
            expect(customerdb['lastOrder3']).to eq 0
            expect(customerdb['award']).to eq 0
        end
=end    end
end