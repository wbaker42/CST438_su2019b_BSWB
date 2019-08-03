class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string 'email'
      t.string 'firstName'
      t.string 'lastName'
      
      t.integer 'lastOrder'
      t.integer 'lastOrder2'
      t.integer 'lastOrder3'
      t.integer 'award'
    end
  end
end
  