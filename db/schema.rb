# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121213034248) do

  create_table "businesses", :force => true do |t|
    t.string   "busi_type"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "group_buys", :force => true do |t|
    t.string   "product_name"
    t.string   "settle_type"
    t.integer  "settle_nums"
    t.float    "settle_money"
    t.integer  "refund_nums"
    t.string   "state"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "foreign_product_id"
    t.string   "busi_type"
    t.string   "platform"
    t.float    "selled_price"
    t.float    "settle_price"
    t.boolean  "is_prepay"
    t.float    "prepay_percentage"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.integer  "selled_nums"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
