class ProductShipmentFactory
  def initialize(overrides = {})
    @overrides = overrides
  end

  def build
    ProductShipment.new(attributes)
  end

  private
    attr_reader :overrides

    def attributes
      {
        rest_of_world: Faker::Boolean.boolean,
        united_states: Faker::Boolean.boolean,
        canada: Faker::Boolean.boolean,
        europe: Faker::Boolean.boolean
      }.merge(overrides)
    end
end
