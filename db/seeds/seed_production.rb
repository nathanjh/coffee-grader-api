# Seedfile loaded in production environment
require 'csv'
# Seed coffees
coffees_file = File.join(Rails.root, 'db', 'seeds', 'coffees.csv')
CSV.foreach(coffees_file, headers: true) { |coffee| Coffee.create(coffee.to_h) }

# Seed roasters
roasters_file = File.join(Rails.root, 'db', 'seeds', 'roasters.csv')
CSV.foreach(roasters_file, headers: :true) { |roaster| Roaster.create(roaster.to_h) }
