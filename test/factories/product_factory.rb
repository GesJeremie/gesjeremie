class ProductFactory
  def initialize(overrides = {})
    @overrides = overrides
  end

  def build
    Product.new(attributes)
  end

  def create
    product = build

    if product.image.attachment.nil?
      product.image.attach(io: placeholder, filename: 'placeholder.png')
    end

    product.save
    product
  end

  private
    attr_reader :overrides

    def attributes
      {
        brand: BrandFactory.new.create,
        diet: ProductDietFactory.new.build,
        price: ProductPriceFactory.new.build,
        shipment: ProductShipmentFactory.new.build,
        allergen: ProductAllergenFactory.new.build,

        name: Faker::FunnyName.name,
        slug: Faker::Internet.slug(nil, '-'),
        kcal_per_serving: Faker::Number.between(10, 30),
        protein_per_serving: Faker::Number.between(10, 30),
        carbs_per_serving: Faker::Number.between(10, 30),
        fat_per_serving: Faker::Number.between(10, 30),
        subscription_available: Faker::Boolean.boolean,
        discount_for_subscription: Faker::Boolean.boolean,
        state: Product::STATES.sample,
        active: true,
        image: nil
      }.merge(overrides)
    end

    def placeholder
      File.open(placeholder_path)
    end

    def placeholder_path
      Rails.root.join('test/fixtures/files/placeholder.png')
    end
end
