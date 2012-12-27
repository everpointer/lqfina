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

ActiveRecord::Schema.define(:version => 20121226092556) do

  create_table "businesses", :force => true do |t|
    t.string   "nick_name"
    t.string   "mobile"
    t.string   "qq"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "group_buys", :force => true do |t|
    t.string   "product_name"
    t.string   "settle_type"
    t.integer  "settle_nums"
    t.decimal  "settle_money", :precision => 12, :scale => 2
    t.integer  "refund_nums"
    t.string   "state"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.float    "dsr"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.string   "busi_contact_person"
    t.string   "busi_contact_phone"
    t.string   "busi_contact_qq"
    t.string   "fina_contact_person"
    t.string   "fina_contact_phone"
    t.string   "openning_bank"
    t.string   "openning_bank_person"
    t.string   "bank_acct"
    t.boolean  "is_public_accounting"
    t.boolean  "has_pay_announce"
    t.integer  "business_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
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
    t.date     "begin_date"
    t.date     "end_date"
    t.integer  "selled_nums"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "partner_id",         :null => false
  end

end
