require 'test_helper'

class GurusAnswersToFiltersTest < ActiveSupport::TestCase
  def answers_to_filters(answers)
    Gurus::AnswersToFilters.new(answers).perform
  end

  test 'converts correctly' do
    assert_equal({ gluten_free: 'on' }, answers_to_filters({ gluten: 'on' }))
    assert_equal({ vegetarian: 'on' }, answers_to_filters({ vegetarian: 'on' }))
    assert_equal({ canada: 'on' }, answers_to_filters({ country: 'canada' }))
    assert_equal({ powder: 'on' }, answers_to_filters({ powder: 'on' }))

    assert_equal({
        lactose_free: 'on',
        gluten_free: 'on',
        vegetarian: 'on'
      },
      answers_to_filters({
        lactose: 'on',
        gluten: 'on',
        vegetarian: 'on'
      })
    )
  end
end
