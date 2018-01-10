Spree::Country.class_eval do
  attr_accessible :name, :iso_name, :iso, :iso3, :states_required
end
