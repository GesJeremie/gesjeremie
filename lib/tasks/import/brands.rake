namespace :import do
  desc 'Import the brands of version 1.0'
  task brands: :environment do

    class ImportBrandsTask
      attr_accessor :brands

      def initialize
      end

      def execute
        set_brands
        import
      end

      private

        def set_brands
          path = Rails.root.join('lib/tasks/import/data/brands.json')
          file = File.read(path)

          @brands = JSON.parse(file)
        end

        def import
          @brands.each do |brand|
            puts "Importing #{brand['name']} ..."

            Brand.where(
              country_id: guess_country_id(brand),
              name: brand['name'],
              website: brand['website'],
              facebook: brand['facebook'],
            ).first_or_create
          end
        end

        def guess_country_id(brand)
          Country.where(code: brand['madeIn']).first.id
        end
    end

    ImportBrandsTask.new.execute
  end
end
