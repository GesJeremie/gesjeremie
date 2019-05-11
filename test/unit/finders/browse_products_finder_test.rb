require 'test_helper'

class BrowseProductsFinderTest < ActiveSupport::TestCase
  include Factories::Support::Traits

  def finder(options)
    BrowseProductsFinder.new(options).perform
  end

  test 'filter by state' do
    create(:product, { state: :powder })
    create(:product, { state: :snack })
    create(:product, { state: :bottle })

    products_powder = finder(filters: { powder: 'on' })
    products_snack = finder(filters: { snack: 'on' })
    products_bottle = finder(filters: { bottle: 'on' })
    products_powder_and_snack = finder(filters: { powder: 'on', snack: 'on' })

    assert_equal 1, products_powder.count
    assert_equal 1, products_snack.count
    assert_equal 1, products_bottle.count
    assert_equal 2, products_powder_and_snack.count

    assert_equal 'powder', products_powder.first.state
    assert_equal 'snack', products_snack.first.state
    assert_equal 'bottle', products_bottle.first.state
    refute_equal 'bottle', products_powder_and_snack.first.state
    refute_equal 'bottle', products_powder_and_snack.second.state
  end

  test 'filter gluten free' do
    create(:product, { allergen: trait_gluten })
    create(:product, { allergen: trait_gluten_free })

    products = finder(filters: { gluten_free: 'on' })

    assert_equal 1, products.count
    assert_equal false, products.first.allergen.gluten?
  end

  test 'filter lactose free' do
    create(:product, { allergen: trait_lactose })
    create(:product, { allergen: trait_lactose_free })

    products = finder(filters: { lactose_free: 'on' })

    assert_equal 1, products.count
    assert_equal false, products.first.allergen.lactose?
  end

  test 'filter vegan' do
    create(:product, { diet: trait_vegan })
    create(:product, { diet: trait_non_vegan })

    products = finder(filters: { vegan: 'on' })

    assert_equal 1, products.count
    assert_equal true, products.first.diet.vegan?
  end

  test 'filter vegetarian' do
    create(:product, { diet: trait_vegetarian })
    create(:product, { diet: trait_non_vegetarian })

    products = finder(filters: { vegetarian: 'on' })

    assert_equal 1, products.count
    assert_equal true, products.first.diet.vegetarian?
  end

  test 'filter by single country' do
    create(:product, { shipment: trait_shipment_united_states })
    create(:product, { shipment: trait_shipment_not_united_states })

    products = finder(filters: { united_states: 'on' })

    assert_equal 1, products.count
    assert_equal true, products.first.shipment.united_states?
  end

  test 'filter by multiple country' do
    create(:product, { shipment: build(:product_shipment, { canada: true, united_states: true}) })
    create(:product, { shipment: build(:product_shipment, { canada: false, united_states: true}) })

    products = finder(filters: { united_states: 'on', canada: 'on' })

    assert_equal 1, products.count
    assert_equal true, products.first.shipment.canada?
    assert_equal true, products.first.shipment.united_states?
  end

  test 'filter by subscription available' do
    create(:product, { subscription_available: true })
    create(:product, { subscription_available: false })

    products = finder(filters: { subscription_available: 'on' })

    assert_equal 1, products.count
    assert_equal true, products.first.subscription_available?
  end

  test 'filter by discount for subscription' do
    create(:product, { discount_for_subscription: true })
    create(:product, { discount_for_subscription: false })

    products = finder(filters: { discount_for_subscription: 'on' })

    assert_equal 1, products.count
    assert_equal true, products.first.discount_for_subscription
  end
end
