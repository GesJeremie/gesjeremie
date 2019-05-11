require 'test_helper'

class BrandsControllerTest < ActionDispatch::IntegrationTest
  test 'display index' do
    get brands_path
    assert_response :success

    10.times { create(:brand) }
    get brands_path
    assert_response :success
  end



  test 'display show' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get brand_path('fake-slug')
    end

    brand = create(:brand)
    get brand_path(brand)
    assert_response :success
  end
end
