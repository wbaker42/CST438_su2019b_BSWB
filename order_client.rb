require 'httparty'
class OrderClient
    include HTTParty
    base_uri "http://localhost:8080"
    #Create a new order
    def self.createOrder(order)
        post '/orders', body: order.to_json,
            headers: {'Content-Type' => 'application/json', 'ACCEPT'=>'application/json'}
    end
    #Get order by order Id, Customer Id or customer email
    def self.getOrder(check, value)
        get "/orders?#{check}=#{value}"
    end
    
    #to register a new customer
    def self.registerCustomer(customerHash)
        post '/customers', body: customerHash.to_json, 
        headers: {'Content-Type'=>'application/json', 'ACCEPT'=>'application/json'}
    end
    #Get customer by customer id or email
    def self .getCustomer(check, value)
        get "/customers?#{check}=#{value}"
    end
    
    #create a new item
    def self.createItem(item)
        post '/items', body: item.to_json, 
                headers: {'Content-Type'=>'application/json', 'ACCEPT'=>'application/json'}
    end
    #get item by item Id
    def self.getItemById(id)
        @item = get "/item/#{id}"
    end
    
end

orderHash = Hash.new()
working=true
while working
    puts "What do you want to do:
            1- To create a new order enter 1
            2- To get order details by Order ID, customer email or customer ID enter 2
            3- To register a new customer enter 3
            4- To look up a customer by customer ID or customer email enter 4
            5- To create a new item enter 5
            6- To look up an item by Item Id enter 6
            7- Quit - to exit"
    input = gets.chomp!
    if(input=='quit')
        working=false
        puts "bye"
        break;
        
    elsif input=='1'
        puts "Enter the item itemId for the order"
        itemId = gets.chomp!
        
        puts "Enter the customer email"
        custEmail = gets.chomp!
       
        orderHash = {itemId: itemId, email: custEmail}
        response = OrderClient.createOrder(orderHash)
       
        puts "status code #{response.code}"
        puts response.body
    
    elsif input == '2'
        puts "To get order by:
                1- OrderId enter: id
                2- Customer Id enter: customerId
                3- Customer email enter: email"
        check = gets.chomp!
        if check == "id"
            puts "Enter the Order Id"
            value = gets.chomp!
        elsif check == "customerId"
            puts "Enter Customer Id:"
            value = gets.chomp!
        elsif check == "email"
            puts "Enter customer email:"
            value = gets.chomp!
        end
        response = OrderClient.getOrder(check, value)
        puts "status code #{response.code}"
        puts response.body
        
    elsif input == "3"
        puts "\nPlease enter first name: "
        firstName = gets.chomp!
        
        puts "\nPlease enter last name: "
        lastName = gets.chomp!
        
        puts "\nPlease enter email: "
        email = gets.chomp!
        customerHash = {email: email, firstName: firstName, lastName: lastName}
        response = OrderClient.registerCustomer(customerHash)
        puts "status code #{response.code}"
        puts response.body
        
    elsif input =="4"
        puts "To Get customer 
            1- by Id enter: id
            2- by email enter: email"
            check = gets.chomp!
            if check == "id"
                puts "Enter the customer Id"
                value = gets.chomp!
            elsif check == "email"
                puts "Enter the customer email"
                value = gets.chomp!
            end
            response = OrderClient.getCustomer(check, value)
            puts "status code #{response.code}"
            puts response.body
    
    elsif input ==  "5"
        puts "Enter the item description"
        itemDescription = gets.chomp!
        puts "Enter the price"
        itemPrice = gets.chomp!
        puts "Enter the stock quantity"
        stockQuantity = gets.chomp!
        itemHash = {description: itemDescription, price: itemPrice, stockQty: stockQuantity}
        response = OrderClient.createItem(itemHash)
        puts "status code #{response.code}"
        puts response.body
    elsif input =="6"
        puts "please enter the Item Id of the item you want to find:"
        itemId = gets.chomp!
        response = OrderClient.getItemById(itemId)
        puts response.code
        puts response.body
    end
end
        