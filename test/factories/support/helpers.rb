module Factories
  module Support
    module Helpers
      def create(factory, overrides = {})
        get_factory(factory).new(overrides).create
      end

      def build(factory, overrides = {})
        get_factory(factory).new(overrides).build
      end

      def get_factory(factory)
        Object.const_get(
          factory.to_s.split('_').map(&:capitalize).join << 'Factory'
        )
      end
    end
  end
end
