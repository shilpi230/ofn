class CreateFarmersMarketSubscribers < ActiveRecord::Migration
  def change
    create_table :farmers_market_subscribers do |t|
      t.string :email
      t.belongs_to :enterprise

      t.timestamps
    end
    add_index :farmers_market_subscribers, :enterprise_id
  end
end
