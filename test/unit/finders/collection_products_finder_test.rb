require 'test_helper'

class CollectionProductsFinderTest < ActiveSupport::TestCase
  include Factories::Support::Traits

  def collections_made_in
    @collections_made_in ||= Rails.application.config.collections_made_in
  end

  def product_price(product)
    product.price.per_day_in_currency(type: :bulk_order, currency: :usd)
  end

  def product_country(product)
    product.brand.country.name.parameterize.underscore
  end

  test 'cheapest' do
    20.times { create(:product) }

    products = CollectionProductsFinder.new('cheapest').perform

    assert_equal 15, products.count
    assert product_price(products.first) <= product_price(products.last)
  end

  test 'for athletes' do
    20.times { create(:product) }

    products = CollectionProductsFinder.new('for-athletes').perform

    assert_equal 15, products.count
    assert products.first.protein_ratio >= products.last.protein_ratio
  end

  test 'for vegans' do
    10.times { create(:product, { diet: trait_vegan }) }
    10.times { create(:product, { diet: trait_non_vegan }) }

    products = CollectionProductsFinder.new('for-vegans').perform

    assert_equal 10, products.count
    assert_equal true, products.first.diet.vegan
  end

  test 'for vegetarians' do
    10.times { create(:product, { diet: trait_vegetarian }) }
    10.times { create(:product, { diet: trait_non_vegetarian }) }

    products = CollectionProductsFinder.new('for-vegetarians').perform

    assert_equal 10, products.count
    assert_equal true, products.first.diet.vegetarian
  end

  test 'gluten free' do
    10.times { create(:product, { allergen: trait_gluten }) }
    10.times { create(:product, { allergen: trait_gluten_free }) }

    products = CollectionProductsFinder.new('gluten-free').perform

    assert_equal 10, products.count
    assert_equal false, products.first.allergen.gluten
  end

  test 'lactose free' do
    10.times { create(:product, { allergen: trait_lactose }) }
    10.times { create(:product, { allergen: trait_lactose_free }) }

    products = CollectionProductsFinder.new('lactose-free').perform

    assert_equal 10, products.count
    assert_equal false, products.first.allergen.lactose
  end

  test 'made in' do
    collections_made_in.each { |country| create(:product, trait_made_in(country)) }

    collections_made_in.each do |country|
      products = CollectionProductsFinder.new("made-in-#{country}").perform

      assert_equal product_country(products.first), country
      assert_equal 1, products.count
    end
  end

  test 'most expensive' do
    20.times { create(:product) }

    products = CollectionProductsFinder.new('most-expensive').perform

    assert_equal 15, products.count
    assert product_price(products.first) >= product_price(products.last)
  end

  test 'powders' do
    10.times { create(:product, { state: 'powder' }) }
    10.times { create(:product, { state: 'bottle' }) }

    products = CollectionProductsFinder.new('powders').perform

    assert_equal 10, products.count
    assert_equal 'powder', products.first.state
  end

  test 'ready to drink' do
    10.times { create(:product, { state: 'bottle' }) }
    10.times { create(:product, { state: 'snack' }) }

    products = CollectionProductsFinder.new('ready-to-drink').perform

    assert_equal 10, products.count
    assert_equal 'bottle', products.first.state
  end

  test 'ready to eat' do
    10.times { create(:product, { state: 'snack' }) }
    10.times { create(:product, { state: 'powder' }) }

    products = CollectionProductsFinder.new('ready-to-eat').perform

    assert_equal 10, products.count
    assert_equal 'snack', products.first.state
  end

end
