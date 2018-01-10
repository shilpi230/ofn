class CreatePayments < ActiveRecord::Migration
  def change
    create_table :stripe_payments do |t|
      t.references :order
      t.string :stripe_customer_id
      t.integer :card_last
      t.boolean :status

      t.timestamps
    end
    add_index :stripe_payments, :order_id
  end
end
