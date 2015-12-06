json.array!(@discounts) do |discount|
  json.extract! discount, :id
  json.url discount_url(discount, format: :json)
end
