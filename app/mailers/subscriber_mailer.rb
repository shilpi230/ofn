class SubscriberMailer < Spree::BaseMailer
  helper HtmlHelper
  helper SpreeCurrencyHelper
  def weekly(email, enterprise_products, order_cycle)
    @email = email
    @enterprise_products = enterprise_products
    @order_cycle = order_cycle
    @market_day = order_cycle.pickup_time_for(order_cycle.coordinator)
    mail(:to => email,
         :from => from_address,
         :subject => "Latest products in subscribed farmers market")
  end
end
