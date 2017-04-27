require 'csv'

namespace :db do
  desc "import city data from local csv to 'cities' table"
  task import_cities_from_csv: :environment do
    puts "Clearing 'cities' table of #{City.count} records..." if City.count > 0
    City.delete_all

    # data source: http://ezlocal.com/blog/post/Top-5000-US-Cities-by-Population.aspx
    csv_path = File.expand_path('../../top_100_cities_by_population.csv', __FILE__)
    csv_text = File.read(csv_path)
    csv = CSV.parse(csv_text, :headers => false)

    csv.each do |row|
      City.create({
        name:row[0].strip,
        state: row[1].strip
      })
      puts "Populated...#{row[0]}"
    end
    puts "\nPopulated with #{City.count} cities!"
  end
end
