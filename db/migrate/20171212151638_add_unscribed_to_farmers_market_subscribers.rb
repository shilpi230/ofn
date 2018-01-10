class AddUnscribedToFarmersMarketSubscribers < ActiveRecord::Migration
  def change
    add_column :farmers_market_subscribers, :unsubscribed, :boolean, default: false
  end
end
