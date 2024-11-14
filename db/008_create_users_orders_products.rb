require 'active_record'

class CreateUsersOrdersProducts < ActiveRecord::Migration[7.0]
  def change
    # Criando a tabela de users
    create_table :users do |t|
      t.string :user_id, limit: 10, null: false, unique: true
      t.string :name, limit: 45
      t.timestamps
    end

    # Criando a tabela de orders
    create_table :orders do |t|
      t.string :order_id, limit: 10, null: false, unique: true
      t.belongs_to :user
      t.decimal :total, precision: 15, scale: 2
      t.date :date
      t.timestamps
    end

    # Criando a tabela de products
    create_table :products do |t|
      t.string :product_id, limit: 10, null: false, unique: true
      t.belongs_to :order
      t.decimal :value, precision: 12, scale: 2
      t.timestamps
    end
  end
end