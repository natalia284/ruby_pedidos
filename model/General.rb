class General 
  attr_accessor :userId, :userName, :orderId, :prodId, :value, :date

  def initialize(userId, userName, orderId, prodId, value, date)
    @userId = userId
    @userName = userName
    @orderId = orderId
    @prodId = prodId
    @value = value
    @date = date
  end

  def print_object
    "userId: #{@userId}, userName: #{@userName}, orderId: #{@orderId}, prodId: #{@prodId}, value: #{@value}, date: #{@date} "
  end
end