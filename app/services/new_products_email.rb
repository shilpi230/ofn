class NewProductsEmail
  def self.run
    enterprise_products = []

    current_order_cycles = OrderCycle.active
    last_order_cycle_products = OrderCycle.most_recently_closed.try(:first).try(:products) || []

    current_enterprises = (current_order_cycles.map(&:suppliers) + current_order_cycles.map(&:distributors)).flatten.uniq
    current_products = current_order_cycles.map(&:products).flatten.uniq - last_order_cycle_products

    current_enterprises.each do |enterprise|
      products = enterprise.active_products_in_order_cycles
        .where('spree_products.id IN (?)', current_products.map(&:id))
      enterprise_products << { enterprise: enterprise, products: products.uniq } # if products.any?
    end

    FarmersMarketSubscriber.where(unsubscribed: false).group_by { |fms| fms.email }.each do |email, fmss|
      eids = fmss.map(&:enterprise_id)
      eps = enterprise_products.map { |ep| ep if eids.include?(ep[:enterprise].id) }
      SubscriberMailer.weekly(email, eps, current_order_cycles.first).deliver if eps.any?
    end
  end
end
