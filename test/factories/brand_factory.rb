class BrandFactory
  def initialize(overrides = {})
    @overrides = overrides
  end

  def build
    Brand.new(attributes)
  end

  def create
    brand = build

    brand.save
    brand
  end

  private
    attr_reader :overrides

    def attributes
      {
        country: Country.all.sample,
        name: Faker::FunnyName.name,
        description: Faker::Lorem.words(4),
        website: Faker::Internet.url,
        facebook: Faker::Internet.url('facebook.com')
      }.merge(overrides)
    end
end
