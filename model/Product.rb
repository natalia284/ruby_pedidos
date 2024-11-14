require 'active_record'

class Product < ActiveRecord::Base
  # self.primary_key = 'product_id'
  belongs_to :order

end