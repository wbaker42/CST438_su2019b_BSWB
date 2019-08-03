class CustomersController < ApplicationController
      before_action :set_customer, only: [:show, :edit, :update, :destroy]
    #GET request
    def index
        if params['email'].present?
            @customer = Customer.where(:email => params['email'])
            if @customer.length>0
                render(json: @customer , status: 200 )
            else #Test this to see if needed.
               render(json: @customer, status: 404)
            end 
        elsif params['id'].present?
            @customer = Customer.where(:id => params['id'])
            if @customer.length>0
                render(json: @customer , status: 200 )
            else
               render(json: @customer, status: 404)
            end 
        else
           render(head :statuscode, status: 404 )
        end
    end

    #POST request.
    def create
        @customer = Customer.new(customer_params)
        if @customer.save
            data = {:id=> @customer.id, :email=> @customer.email, :firstName =>@customer.firstName, :lastName => @customer.lastName,
                    :lastOrder=> @customer.lastOrder, :lastOrder2=> @customer.lastOrder2, :lastOrder3 => @customer.lastOrder3, :award => @customer.award
            }
            render(json: data , status: 201 )
        else
            render(json: @customer.errors, status: 400 )
        end

    end
    
    def update
        if @customer.length > 0
            if params['award'] == 0
                if @customer.pluck(:lastOrder)[0] == nil
                    @customer.update(:lastOrder => params['total'])
                    render(json: @customer , status: 204 )
                #elsif @customer.update(customer_params)
                    #render(json: @customer , status: 204 )
                elsif @customer.pluck(:lastOrder2)[0] == nil
                    @customer.update(:lastOrder2 => params['total'])
                    render(json: @customer , status: 204 )
                elsif @customer.pluck(:lastOrder3)[0] == nil
                    @customer.update(:lastOrder3 => params['total'])
                    award = (@customer.pluck(:lastOrder)[0] + @customer.pluck(:lastOrder2)[0] + @customer.pluck(:lastOrder3)[0])/30  
                    
                    @customer.update(:award => award)
                    render(json: @customer , status: 204 )
                else
                   # render(json: @customer, status: 400 )
                end
            else
                @customer.update(:lastOrder => 0)
                @customer.update(:lastOrder2 => 0)
                @customer.update(:lastOrder3 => 0)
                @customer.update(:award => 0)
                render(json: @customer , status: 204 )
            end
        else
            render(json: @customer, status: 400 )
        end
            
    end
    
    def customer_params
        params.require(:customer).permit(:email, :firstName, :lastName)

    end
    def set_customer

      @customer = Customer.where(:id => params['customerId'])

    end
    def new
        @customer = Customer.new
    end
end   

=begin                data = {:id => @customer.pluck(:id)[0], 
                        :email => @customer.pluck(:email)[0], 
                        :firstName => @customer.pluck(:firstName)[0], 
                        :lastName => @customer.pluck(:lastName)[0], 
                        :lastOrder => @customer.pluck(:lastOrder)[0], 
                        :lastOrder2 => @customer.pluck(:lastOrder2)[0], 
                        :lastOrder3 => @customer.pluck(:lastOrder3)[0], 
                        :award => @customer.pluck(:award)[0], 
=end                }