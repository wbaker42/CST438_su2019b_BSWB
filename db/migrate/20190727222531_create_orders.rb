class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer 'itemId'
      t.string 'description'
      t.integer 'customerId'
      t.integer 'price'
      t.integer 'total'
      t.integer 'award'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end
end
