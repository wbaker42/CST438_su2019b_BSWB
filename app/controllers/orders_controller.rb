class OrdersController < ApplicationController
     #POST /orders
    def create
        #create a new order
        @order = Order.new
        
        #retrieving the customer information from the customer app
        code, @customer = Customer.getCustomerByEmail(params[:email])
        #response = Customer.getCustomerByEmail(params[:email])
        
        #@customer = JSON.parse response.body
        #p response, "This was the response"
        #if code != 200 #customer doesn't exist
        if code !=200
           # render(json: @order, status: 400) #give error message
            render(json: {messages: 'Customer email you entered does not exist'}, status: 400)
            return #return as customer doesnt exit order can't be created
        end
        
        #retrieving the item information from item  app
        code, @item = Item.getItemById(params[:itemId])
        #@item = Item.getItemById(params[:itemId])
        #response = Item.getItemById(params[:itemId])
        if code != 200 #the item doesn't exist
            render(json: {messages: 'Item id you entered does not exist'}, status: 400)
            #render(json: @order, status: 400)
            return
        end
        #@item = JSON.parse response.body
        #checking if the stock qty is 0 the order can't be processed
        if @item['stockQty'] == 0
            render(json: @order, status: 400)
            return
        end
        #processing and creating the order
        @order.customerId = @customer["id"]
        @order.award = @customer["award"]  
        @order.description = @item['description']
        @order.itemId = @item['id']
        @order.price = @item['price'] 

        if @customer['award']==nil
            @order.total = @item['price']
        else
            @order.total = @item['price'] - @customer['award']
        end
        if @order.save
            itemHash = Hash.new
            itemHash = {id: @order.itemId}
            Item.putOrder(itemHash)
            orderHash = Hash.new
            orderHash = {custId: @order.customerId, total: @item['price']}
            Customer.updateCustomerOrder(orderHash)
            render(json: @order, status: 201)
        else
            render(json: {mesages: @order.errors.messages}, status: 400)
        end
    end

    #GET/orders by order id customer id or customer email
    def getOrder
        if request.query_string.present? 
            if params[:id].present?
                @order=Order.find_by(id: params[:id])
                if @order.nil?
                    render(json: {messages: 'Order for the order Id not found'}, status: 404)
                    #head 404 #error - not found
                else
                    render "order.json.jbuilder"
                end
            elsif params[:customerId].present?
                @order = Order.where(:customerId => params[:customerId])
                #@order is an ActiveRecord::Relation @order.where returns an ActiveRecord::Relation
                #converting @order to an array of Order objects
               # @order=@order.to_a
                #if @order.nil?
                if @order.empty?
                    #head 404 #error - not found
                    render(json: {messages: 'Order for customer Id not found'}, status: 404)
                else
                    @order=@order.to_a
                    render "abc.json.jbuilder"
                end 
            elsif params[:email].present?
                #retrieving the customer information from the customer app
                code, @customer = Customer.getCustomerByEmail(params[:email]) #customer is the response from the method
                                                                    # in customer helper class
                id=@customer["id"]
                p id, "This is the customer ID"
                #find the order using the customer Id
                @order = Order.where(:customerId => id)
                @order.to_a
                if @order.empty?
                    #head 404 #error - not found
                    render(json: {messages: 'Order for customer email not found'}, status: 404)
                else
                    render "abc.json.jbuilder"
                end 
            else
                 render(json: {messages: 'Order not found'}, status: 404)
            end    
        end
    end

    #RegisterCustomer
    def regCustomer
        customerHash = {email: params[:email], firstName: params[:firstName], lastName: params[:lastName]}
        @customer = Customer.createCustomer(customerHash) #call the helper class Customer method
        render(json: @customer, status: 200)
    end
    
    #get customer by email or get customer by id
    def getCustomer
        if request.query_string.present? 
            if params[:email].present?
                code, @customer = Customer.getCustomerByEmail(params[:email]) #Calling the helper Customer class method 
                                                                        #which sends back a response
                if code == 404
                    #head 404 #error - not found
                    render(json: {messages: 'Customer email not found'}, status: 404)
                else
                    render(json: @customer, status: 200)
                end
            elsif params[:id].present?
                response = Customer.getCustomerById(params[:id]) #Calling the helper Customer class method
                if response.code == 404
                    render(json: {messages: 'Customer id not found'}, status: 404)
                    #head 404 #error - not found
                else
                    @customer = JSON.parse response.body
                    render(json: @customer, status: 200)
                end
            end
        else
            head 404
        end
    end
    
    #create Item
    def createItem
        itemHash = Hash.new
        itemHash = {id: params[:id], description: params[:description], price: params[:price], stockQty: params[:stockQty]}
        @item = Item.createItem(itemHash)
        if @item.nil?
            head 404 #error - not found
        else
            @item = render(json: @item, status: 200)
        end
    end
    
    #get item by Id
    def getItemById
        if params[:id].present?
            code, @item = Item.getItemById(params[:id])
            if response.code == 404
                #head 404 #error - not found
                render(json: {messages: 'Item not found'}, status: code)
            else
               
                render(json: @item, status: 200)
            end
        #else
        #    #head 404 #error - not found
        #    render(json: {messages: 'Item not found'}, status: 404)
        end
    end
end