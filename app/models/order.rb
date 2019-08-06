class Order < ActiveRecord::Base
    validates :itemId, presence: true
    validates :customerId, presence: true

end