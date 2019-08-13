json.array!(@order) do |order|
    json.extract!(order, :id, :itemId, :description, :customerId, :price, :award, :total, :created_at, :updated_at)
end