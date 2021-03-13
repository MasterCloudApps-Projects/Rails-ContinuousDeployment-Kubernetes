json.extract! product, :id, :title, :detail, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
