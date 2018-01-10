Spree::OrderMailer.class_eval do
  helper HtmlHelper
  helper CheckoutHelper
  helper SpreeCurrencyHelper

  def cancel_email(order, resend = false)
    @order = find_order(order)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{t('order_mailer.cancel_email.subject')} ##{order.number}"
    mail(to: order.email, from: from_address, subject: subject)
  end

  def confirm_email_for_customer(order, resend = false)
    find_order(order) # Finds an order instance from an id
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"
    mail(:to => @order.email,
         :from => from_address,
         :subject => subject,
         :reply_to => @order.distributor.email)
  end

  def confirm_email_for_shop(order, enterprise = nil ,resend = false)
    find_order(order) # Finds an order instance from an id
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"
    @items = @order.group_by_supplier[enterprise]
    @enterprise = Enterprise.find_by_name(enterprise)
    mail(:to => @enterprise.email,
       :from => from_address,
       :subject => subject)
  end

  def invoice_email(order, pdf)
    find_order(order) # Finds an order instance from an id
    attachments["invoice-#{@order.number}.pdf"] = pdf if pdf.present?
    subject = "#{Spree::Config[:site_name]} #{t(:invoice)} ##{@order.number}"
    mail(:to => @order.email,
         :from => from_address,
         :subject => subject,
         :reply_to => @order.distributor.email)
  end

  def farmer_pickup_report(supplier, distributor, order_cycle)
    @supplier = supplier
    @distributor = distributor
    orders = Spree::Order.where(order_cycle_id: order_cycle.id, distributor_id: distributor.id)
    @line_items = orders.map(&:line_items).flatten.select { |li| li.product.supplier_id == supplier.id }
    @products = @line_items.group_by { |item| item.variant_id }
    @order_by_customers = @distributor.order_group_customer(order_cycle)
    subject = "#{t('email_pickup_reminder_subject', enterprise: order_cycle.coordinator.name, pickup: order_cycle.pickup_time_for(order_cycle.coordinator) )}"
    mail(:to => @supplier.email, :from => from_address, :subject => subject)
  end

  def customer_report(order, order_cycle)
    find_order(order) # Finds an order instance from an id
    subject = "#{t('email_pickup_reminder_subject', enterprise: order_cycle.coordinator.name, pickup: order_cycle.pickup_time_for(order.distributor))}"
    mail(:to => @order.email,
         :from => from_address,
         :subject => subject,
         :reply_to => @order.distributor.email)
  end

  def find_order(order)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
  end
end
