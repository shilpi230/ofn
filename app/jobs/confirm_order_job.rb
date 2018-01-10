ConfirmOrderJob = Struct.new(:order_id) do
  def perform
    Spree::OrderMailer.confirm_email_for_customer(order_id).deliver
    order = Spree::Order.find(order_id)
    order.group_by_supplier.keys.each do |supplier|
      Spree::OrderMailer.confirm_email_for_shop(order_id, supplier).deliver
    end
  end
end
