  require 'rails_helper'
RSpec.describe "Orders", type: :request do
@headers = { "CONTENT_TYPE" => "application/json" , "ACCEPT" => "application/json"}  
        before(:each) do 
            # create database record for Test Dummy
    
            order = { itemId: 227, 
                    email: 'xy@csumb.edu' } 
            headers = {"CONTENT_TYPE" => "application/json" ,
                    "ACCEPT" => "application/json"}
                         
            expect(Customer).to receive(:getCustomerByEmail).with('xy@csumb.edu') do
                [ 200, {'id' => 2, 'award'=> 0 } ]
            end 
            
            expect(Item).to receive(:getItemById).with(227) do
                [ 200, { 'id'=>227, 'description'=>'makeup',
                          'price'=> 50.00, 'stockQty'=> 100 } ]
            end 
            
            allow(Customer).to receive(:updateCustomerOrder) do |order|
                expect(order[:custId]).to eq 2 
                201
            end 
            
            allow(Item).to receive(:putOrder) do |order|
                expect(order[:id]).to eq 227
                201
            end 
            post '/orders', params: order.to_json, headers: headers

        end
    describe "POST /orders" do
        it "customer makes purchase" do
            order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
            
            headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
                     
            expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 200, {'id' => 1, 'award'=> 0 } ]
            end 
            
            expect(Item).to receive(:getItemById).with(100) do
            [ 200, { 'id'=>100, 'description'=>'jewelry item',
                          'price'=> 175.00, 'stockQty'=> 2 } ]
            end 
            
            allow(Customer).to receive(:updateCustomerOrder) do |order|
            expect(order[:custId]).to eq 1 
            201
            end 
            
            allow(Item).to receive(:putOrder) do |order|
            expect(order[:id]).to eq 100
            201
            end 
            
            post '/orders', params: order.to_json, headers: headers
            
            expect(response).to have_http_status(201)
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
                'updated_at'
                )
            orderdb = Order.find(order['id'])
            expect(orderdb['itemId']).to eq 100
            expect(orderdb['customerId']).to eq 1
            expect(orderdb['price']).to eq 175.00
            expect(orderdb['description']).to eq "jewelry item"

        end
        it "customer makes purchase and an award is applied to total" do
            order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
            
            headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
                     
            expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 200, {'id' => 1, 'award'=> 100 } ]
            end 
            
            expect(Item).to receive(:getItemById).with(100) do
            [ 200, { 'id'=>100, 'description'=>'jewelry item',
                          'price'=> 175.00, 'stockQty'=> 2 } ]
            end 
            
            allow(Customer).to receive(:updateCustomerOrder) do |order|
            expect(order[:custId]).to eq 1 
            201
            end 
            
            allow(Item).to receive(:putOrder) do |order|
            expect(order[:id]).to eq 100
            201
            end 
            
            post '/orders', params: order.to_json, headers: headers
            
            expect(response).to have_http_status(201)
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
                'updated_at'
                )
            orderdb = Order.find(order['id'])
            expect(orderdb['itemId']).to eq 100
            expect(orderdb['customerId']).to eq 1
            expect(orderdb['price']).to eq 175.00
            expect(orderdb['total']).to eq 75.00
            expect(orderdb['description']).to eq "jewelry item"

        end        
        it "Invalid customer attempts to make a purchase" do
          order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
          expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 204, nil ]
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
        it "Valid customer attempts to purchase an out of stock item" do
          order = { itemId: 100, 
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
          expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
            [ 200, {'id' => 1, 'award'=> 0 } ]
          end 
          
          expect(Item).to receive(:getItemById).with(100) do
            [ 200, { 'id'=>100, 'description'=>'jewelry item',
                          'price'=> 175.00, 'stockQty'=> 0 } ]
          end 
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(400)        
        end
    end
    
    describe "GET /orders" do
        it "Access order by order ID" do
            get '/orders?id=1', headers: @headers
            order = JSON.parse(response.body)
            expect(response).to have_http_status(200)
            expect(order.keys).to contain_exactly(
                'id',
                'itemId',
                'description',
                'customerId',
                'price',
                'award',
                'total',
                'created_at',
                'updated_at'
                )
            orderdb = Order.find(order['id'])
            expect(orderdb['itemId']).to eq 227
            expect(orderdb['customerId']).to eq 2
            expect(orderdb['price']).to eq 50.00
            expect(orderdb['description']).to eq "makeup"
        end
        it "Attempts to access an invalid order ID" do
            get '/orders?id=1234', header: @headers
            expect(response).to have_http_status(404)
        end
        
        it "Access order by customer ID" do
            get '/orders?customerId=2', headers: @headers
            order = JSON.parse(response.body)[0]
            expect(response).to have_http_status(200)
            expect(order.keys).to contain_exactly(
                'id',
                'itemId',
                'description',
                'customerId',
                'price',
                'award',
                'total',
                'created_at',
                'updated_at'
                )

            orderdb = Order.find(order['id'])
            expect(orderdb['itemId']).to eq 227
            expect(orderdb['customerId']).to eq 2
            expect(orderdb['price']).to eq 50.00
            expect(orderdb['description']).to eq "makeup"
        end
        it "Attempts to access an invalid order ID" do
            get '/orders?customerId=1234', header: @headers
            expect(response).to have_http_status(404)
        end
        
        it "Access order by email" do
            expect(Customer).to receive(:getCustomerByEmail).with('xy@csumb.edu') do
                [ 200, {'id' => 2, 'award'=> 0 } ]
            end 
            get '/orders?email=xy@csumb.edu', headers: @headers
            order = JSON.parse(response.body)[0]

            expect(response).to have_http_status(200)
            expect(order.keys).to contain_exactly(
                'id',
                'itemId',
                'description',
                'customerId',
                'price',
                'award',
                'total',
                'created_at',
                'updated_at'
                )

            orderdb = Order.find(order['id'])
            expect(orderdb['itemId']).to eq 227
            expect(orderdb['customerId']).to eq 2
            expect(orderdb['price']).to eq 50.00
            expect(orderdb['description']).to eq "makeup"
        end
        it "Attempts to access an invalid order ID" do
            expect(Customer).to receive(:getCustomerByEmail).with('test1234@email.com') do
                [ 200, {'id' => nil, 'award'=> nil } ]
            end 
            get '/orders?email=test1234@email.com', header: @headers
            expect(response).to have_http_status(404)
        end

    end
end