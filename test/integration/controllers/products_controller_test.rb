require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'display index' do
    get products_path
    assert_response :success

    10.times { create(:product) }
    get products_path
    assert_response :success
  end



  test 'display show' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get product_path('fake-slug')
    end

    product = create(:product)

    get product_path(product)
    assert_response :success
  end
end
