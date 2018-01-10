class CreateSpreeUserSearches < ActiveRecord::Migration
  def change
    create_table :spree_user_searches do |t|
      t.string :email
      t.string :term
      t.string :user_ip

      t.timestamps
    end
  end
end
