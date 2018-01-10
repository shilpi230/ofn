class OrderCycleService
  def self.run
    order_cycles = OrderCycle.where(orders_close_at: 10.days.ago..Time.now)
    order_cycles.each do |order_cycle|
      order_cycle.distributors.each do |distributor|
        distributor.customers.each do |customer|
          customer.orders.where(created_at: (order_cycle.orders_open_at)..(order_cycle.orders_close_at)).each do |order|
            Spree::OrderMailer.customer_report(order, order_cycle).deliver if order.completed?
          end
        end
        order_cycle.suppliers.each do |supplier|
          Spree::OrderMailer.farmer_pickup_report(supplier, distributor, order_cycle).deliver
        end
      end
    end
  end
end
