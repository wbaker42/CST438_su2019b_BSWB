class Customer < ActiveRecord::Base
    validates :lastName, presence: true
    validates :firstName, presence: true
    validates :email, presence: true
    validates :email, uniqueness: true
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
end