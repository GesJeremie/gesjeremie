namespace :import do
  desc 'Import the products of version 1.0'
  task products: :environment do

    class ImportProductsTask
      attr_accessor :products

      def initialize
      end

      def execute
        set_products
        import
      end

      private

        def set_products
          path = Rails.root.join('lib/tasks/import/data/products.json')
          file = File.read(path)

          @products = JSON.parse(file)
        end

        def import
          @products.each do |product|
            puts "Importing #{product['name']} ..."

            record = Product.new(
              brand_id: guess_brand_id(product),
              name: product['name'],
              kcal_per_serving: product['nutritionFacts']['kcal'],
              protein_per_serving: product['nutritionFacts']['protein'],
              carbs_per_serving: product['nutritionFacts']['carbs'],
              fat_per_serving: product['nutritionFacts']['fat'],
              subscription_available: product['filters']['hasSubscription'],
              discount_for_subscription: product['filters']['hasDiscountForSubscription'],
              state: 'powder',
              notes: product['notes'],
              slug: create_slug(product['name']),
              active: true
            )

            record.diet = ProductDiet.new(
              vegan: product['filters']['isVegan'],
              vegetarian: product['filters']['isVegetarian'],
              ketogenic: false
            )

            record.allergen = ProductAllergen.new(
              gluten: !product['filters']['isGlutenFree'],
              lactose: !product['filters']['isLactoseFree'],
              nut: false,
              ogm: false,
              soy: false
            )

            record.price = ProductPrice.new(
              currency_id: guess_currency_id(product),
              per_serving_minimum_order: product['prices']['base']['minimumOrderPerMeal'],
              per_serving_bulk_order: product['prices']['base']['maximumOrderPerMeal']
            )

            record.shipment = ProductShipment.new(
              rest_of_world: product['filters']['canShipInternational'],
              united_states: product['filters']['canShipUS'],
              canada: product['filters']['canShipCA'],
              europe: product['filters']['canShipEU']
            )

            record = attach_image(record, product['slug'])

            puts "Saving ... #{record.save}"
          end
        end

        def guess_brand_id(product)
          Brand.where('name LIKE ?', "%#{product['brandSlug'].gsub('-', ' ').split.first.upcase_first}%").first.id
        end

        def guess_currency_id(product)
          Currency.where(code: product['prices']['base']['currency']).first.id
        end

        def attach_image(record, slug)
          product_image_path = image_product_path(slug)

          if File.exist?(product_image_path)
            record.image.attach(io: File.open(product_image_path), filename: "#{slug}.png")
          else
            record.image.attach(io: File.open(image_placeholder_path), filename: 'placeholder.png')
          end

          record
        end

        def image_product_path(slug)
          Rails.root.join("lib/tasks/import/data/product_images/#{slug}.png")
        end

        def image_placeholder_path
          Rails.root.join('lib/tasks/import/data/placeholder.png')
        end

        def create_slug(string)
          string.parameterize.truncate(80, omission: '')
        end
    end

    ImportProductsTask.new.execute
  end
end
