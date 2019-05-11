module Factories
  module Support
    module Traits
      def trait_vegetarian
        build(:product_diet, { vegetarian: true })
      end

      def trait_non_vegetarian
        build(:product_diet, { vegetarian: false })
      end

      def trait_vegan
        build(:product_diet, { vegan: true })
      end

      def trait_non_vegan
        build(:product_diet, { vegan: false })
      end

      def trait_gluten
        build(:product_allergen, { gluten: true })
      end

      def trait_gluten_free
        build(:product_allergen, { gluten: false })
      end

      def trait_lactose
        build(:product_allergen, { lactose: true })
      end

      def trait_lactose_free
        build(:product_allergen, { lactose: false })
      end

      def trait_shipment_united_states
        build(:product_shipment, { united_states: true })
      end

      def trait_shipment_canada
        build(:product_shipment, { canada: true })
      end

      def trait_shipment_not_united_states
        build(:product_shipment, { united_states: false })
      end

      def trait_made_in(country)
        country = Country.find_by_name(country.titleize)

        { brand: create(:brand, { country: country }) }
      end
    end
  end
end
