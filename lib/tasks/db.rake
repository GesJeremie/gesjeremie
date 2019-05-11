namespace :db do
  desc 'Setup the db or migrate depending on state of db'
  task setup_or_migrate: :environment do

    class SetupOrMigrate

      def initialize
      end

      def execute
        if database_exists?
          migrate
        else
          setup
        end
      end

      private

        def setup
          Rake::Task['db:create'].invoke
          Rake::Task['db:migrate'].invoke
          Rake::Task['db:seed'].invoke
          Rake::Task['import:brands'].invoke
          Rake::Task['import:products'].invoke
        end

        def migrate
          Rake::Task['db:migrate'].invoke
        end

        def database_exists?
          begin
            ActiveRecord::Base.connection
          rescue ActiveRecord::NoDatabaseError
            false
          else
            true
          end
        end
    end

    SetupOrMigrate.new.execute
  end
end
