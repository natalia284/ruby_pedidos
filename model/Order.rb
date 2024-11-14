require 'active_record'

class Order < ActiveRecord::Base
  # self.primary_key = 'order_id'
  belongs_to :user
  has_many :products
end