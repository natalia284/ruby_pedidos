require_relative '../model/User'
require_relative '../model/Order'
require_relative '../model/Product'
require_relative '../model/Filename'
require_relative '../model/General'

require 'active_record'
require 'pg'

require_relative '../database_setup.rb'

def read_lines(filename, saida, fileId)

  File.open(filename, "r") do |data|
    File.open(saida, "w") do |saida|
      for line in data
        # saida.puts line
        slip_data(line, saida, fileId)
      end
    end
  end 
end
  

def slip_data(line, saida, fileId)

  # User 
  userId = line.slice(0, 10)
  userName = line.slice(10, 45)
  orderId = line.slice(55, 10)

  #Order
  date = line.slice(87, 8) 

  # Product
  prodId = line.slice(65, 10)
  value_p = line.slice(75, 12)

  # saida.puts orderId

  add_database(userId, userName, orderId, date, prodId, value_p, saida, fileId)

end

def add_database(userId, userName, orderId, date, prodId, value_p, saida, fileId)

  userId = userId.strip

  if userId.length < 10
    userId = userId.rjust(10, '0')
  end

  if !User.find_by(user_id: userId) 

    User.create(
      file_id: fileId, 
      user_id: userId, 
      name: userName.strip
    )
  end

  add_order(orderId, userId, date, prodId, value_p, saida, fileId)
    
end

def add_order(orderId, userId, date, prodId, value_p, saida, fileId)

  orderId = orderId.strip

  date = Date.strptime(date, '%Y%m%d').to_s

  if orderId.length < 10
    orderId = orderId.rjust(10, '0')
    puts orderId
  end

  if !Order.find_by(order_id: orderId)

    Order.create(
      file_id: fileId, 
      order_id: orderId,
      user_id: userId, 
      date: date
    )
  end

    add_product(prodId, orderId, value_p, fileId)
end


def add_product(prodId, orderId, value_p, fileId)

  prodId = prodId.strip

  if prodId.length < 10
    prodId = prodId.rjust(10, '0')
    puts prodId
  end

  product = Product.create(
    file_id: fileId, 
    product_id: prodId, 
    order_id: orderId, 
    value: value_p
  )

  if product.persisted?
    total = Product.where(order_id: orderId).sum(:value)
    order = Order.find(orderId)
    order.update_column(:total, total)

    puts "Novo total #{total}"
  end
end
  
def add_file(hash, name_file)
  
  filename = Filename.create(
    file_hash: hash,
    filename: name_file
  )
  
  return filename.id
end


  

# read_lines("/home/natalia/Documentos/desafio/testes.txt", "/home/natalia/Documentos/desafio/saida.txt")
