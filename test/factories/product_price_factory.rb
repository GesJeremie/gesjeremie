class ProductPriceFactory
  def initialize(overrides = {})
    @overrides = overrides
  end

  def build
    ProductPrice.new(attributes)
  end

  private
    attr_reader :overrides

    def attributes
      {
        currency: Currency.popular.sample,
        per_serving_minimum_order: Faker::Number.between(5, 10),
        per_serving_bulk_order: Faker::Number.between(3, 6)
      }.merge(overrides)
    end
end
