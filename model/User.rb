require 'active_record'

class User < ActiveRecord::Base
  has_many :orders
  # self.primary_key = 'user_id'
end