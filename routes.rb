require 'sinatra'
require 'json'
require 'active_record'

require_relative 'model/User'
require_relative 'model/Order'
require_relative 'model/Product'
require_relative 'model/Filename'
require_relative 'model/General'

require_relative 'services/file'

require_relative 'database_setup.rb'

post '/upload' do

  file = params[:file]
  file_name = file[:filename]

  if file && file[:tempfile]
    # Garante que o arquivo tenha um nome razoável para evitar erro de nome longo
    temp_file_name = "uploaded_file_#{Time.now.to_i}.txt"
    puts "Arquivo temporário nomeado como: #{temp_file_name}"

    file_content = file[:tempfile].read

    file_hash = Digest::MD5.hexdigest(file_content)

    puts "Conteúdo do arquivo: #{file_content[0..100]}..."  # Exibindo os primeiros 100 caracteres para depuração
    
    exist_file = Filename.find_by(file_hash: file_hash)

    if exist_file

      id_file_return = exist_file.id

      users_data = []

      users = User.includes(orders: :products).where(file_id: id_file_return)

      users.each do |user|
        user_orders = user.orders.map do |order|
          {
            order_id: order.order_id,
            total: order.total,
            date: order.date,
            products: order.products.map { |product| { product_id: product.product_id, value: product.value } }
          }
        end

        users_data << {
          user_id: user.user_id,
          name: user.name,
          orders: user_orders
        }
      end

      content_type :json
      JSON.pretty_generate(users_data)

      # content_type :json
      # status 200
      # return { message: 'Arquivo já existe no sistema', data: users_data }.to_json
    
      # puts "Arquivo já foi subido!"
    else
      id_file_return = add_file(file_hash, file_name)
      read_lines(file[:tempfile].path, "saida.txt", id_file_return)

      User.where("created_at >= ?", Time.now.beginning_of_day).update_all(file_id: id_file_return)
      Order.where("created_at >= ?", Time.now.beginning_of_day).update_all(file_id: id_file_return)
      Product.where("created_at >= ?", Time.now.beginning_of_day).update_all(file_id: id_file_return)

      puts "Arquivo carregado com sucesso!"

      users_data = []

      users = User.includes(orders: :products).where(file_id: id_file_return)

      users.each do |user|
        user_orders = user.orders.map do |order|
          {
            order_id: order.order_id,
            total: order.total,
            date: order.date,
            products: order.products.map { |product| { product_id: product.product_id, value: product.value } }
          }
        end

        users_data << {
          user_id: user.user_id,
          name: user.name,
          orders: user_orders
        }
      end

      content_type :json
      JSON.pretty_generate(users_data)
    end
  else
    status 400
    { error: 'Arquivo não enviado' }.to_json
  end
end

    




