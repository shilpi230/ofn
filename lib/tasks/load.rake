namespace :db do
  task load: :environment do
    require_relative '../../spec/factories'
    require_relative '../../spec/support/spree/init'
    task_name = "db:load"

    # Seeds taxons
    puts "[#{task_name}] Seeding taxonomies"
    taxonomy = Spree::Taxonomy.find_by_name('Products') || FactoryGirl.create(:taxonomy, :name => 'Products')
    taxonomy_root = taxonomy.root
    ['Vegetables', 'Fruit', 'Oils', 'Preserves and Sauces', 'Dairy', 'Meat and Fish'].each do |taxon_name|
      FactoryGirl.create(:taxon, :name => taxon_name, :parent_id => taxonomy_root.id)
    end
  end
end
