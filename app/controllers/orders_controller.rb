class OrdersController < ApplicationController
     #POST /orders
    def create
        #create a new order
        @order = Order.new
        
        #retrieving the customer information from the customer app
        code, customer = Customer.getCustomerByEmail(params[:email])
        
        if code != 200 #customer doesn't exist
            render(json: @order, status: 400) #give error message
            return #return as customer doesnt exit order can't be created
        end
        
        #retrieving the item information from item  app
        code, item = Item.getItemById(params[:itemId])
        
        if code != 200 #the item doesn't exist
            render(json: @order, status: 400)
            return
        end
        #checking if the stock qty is 0 the order can't be processed
        if item['stockQty'] == 0
            render(json: @order, status: 400)
            return
        end
        #processing and creating the order
        @order.customerId = customer[0]["id"]
        @order.award = customer[0]["award"]  
        @order.description = item['description']
        @order.itemId = item['id']
        @order.price = item['price'] 
        if customer[0]['award']==nil
            @order.total = item['price']
        else
            @order.total = item['price'] - customer[0]['award']
        end
        if @order.save
            itemHash = Hash.new
            itemHash ={id: @order.itemId}
            Item.putOrder(itemHash)
            orderHash = Hash.new
            orderHash = {custId: @order.customerId, total: item['price']}
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
                    head 404 #error - not found
                else
                    render "order.json.jbuilder"
                end
            elsif params[:customerId].present?
                @order = Order.where(:customerId => params[:customerId])
                #@order is an ActiveRecord::Relation @order.where returns an ActiveRecord::Relation
                #converting @order to an array of Order objects
                @order=@order.to_a
                if @order.nil?
                    head 404 #error - not found
                else
                    render "abc.json.jbuilder"
                end 
            elsif params[:email].present?
                #retrieving the customer information from the customer app
                @customer = Customer.getCustomerByEmail(params[:email]) #customer is the response from the method
                                                                    # in customer helper class
                id=@customer["id"]
                #find the order using the customer Id
                @order = Order.where(:customerId => id)
                @order.to_a
                if @order.nil?
                    head 404 #error - not found
                else
                    render "abc.json.jbuilder"
                end 
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
                @customer = Customer.getCustomerByEmail(params[:email]) #Calling the helper Customer class method
                if @customer.nil?
                    head 404 #error - not found
                else
                    render(json: @customer, status: 200)
                end
            elsif params[:id].present?
                @customer = Customer.getCustomerById(params[:id]) #Calling the helper Customer class method
                if @customer.nil?
                    head 404 #error - not found
                else
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
            render(json: @item, status: 200)
        end
    end
    
    #get item by Id
    def getItemById
        if params[:id].present?
            @item = Item.getItemById(params[:id])
            if @item.nil?
                head 404 #error - not found
            else
                render(json: @item, status: 200)
            end
        else
            head 404 #error - not found
        end
    end
end