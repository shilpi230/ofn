class Spree::UserSearch < ActiveRecord::Base
  attr_accessible :email, :term, :user_ip
   validates :term, presence: true
end
