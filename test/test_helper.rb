ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Load factories
Dir[Rails.root.join('test/factories/**/*.rb')].each { |file| require file }

class ActiveSupport::TestCase
  include Factories::Support::Helpers
  include Factories::Support::Traits

  def self.prepare
    Rails.application.load_seed
  end
  prepare

  def setup
    # Add code that need to be executed before each test
  end

  def teardown
    # Add code that need to be executed after each test
  end
end
