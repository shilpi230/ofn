class AddCreditCardToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :credit_card, :string
  end
end
