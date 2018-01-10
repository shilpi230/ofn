# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# -- Spree
unless Spree::Country.find_by_name 'United States'
  puts "[db:seed] Seeding Spree"
  Spree::Core::Engine.load_seed if defined?(Spree::Core)
  Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
end

# -- States
unless Spree::State.find_by_name 'New York'
  country = Spree::Country.find_by_name('United States')
  puts "[db:seed] Seeding states"

  [
   ['Alaska', 'AK'],
   ['West Virginia', 'WV'],
   ['New York', 'NY']
  ].each do |state|
    Spree::State.create!({"name"=>state[0], "abbr"=>state[1], :country=>country}, :without_protection => true)
  end
end

Rake.invoke['db:load']
