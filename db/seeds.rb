load File.join(Rails.root, 'db', 'seeds', 'seed_development.rb') if Rails.env.development?

load File.join(Rails.root, 'db', 'seeds', 'seed_production.rb') if Rails.env.production?
