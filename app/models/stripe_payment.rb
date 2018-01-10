class StripePayment < ActiveRecord::Base
  belongs_to :order
  attr_accessible :status, :card_last, :stripe_customer_id
end
