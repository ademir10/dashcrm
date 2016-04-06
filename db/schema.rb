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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160406205057) do

  create_table "advices", force: :cascade do |t|
    t.string   "description"
    t.string   "type_advice"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "airsearches", force: :cascade do |t|
    t.string   "client"
    t.string   "phone"
    t.integer  "q1"
    t.integer  "q2"
    t.integer  "q3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.string   "description"
    t.integer  "score"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "link"
  end

  create_table "expire_dates", force: :cascade do |t|
    t.date     "date_expire"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "question"
    t.integer  "score"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "quizzes", ["category_id"], name: "index_quizzes_on_category_id", using: :btree

  create_table "researches", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "user"
    t.string   "client"
    t.string   "cellphone"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "researches", ["category_id"], name: "index_researches_on_category_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "a1"
    t.integer  "a2"
    t.integer  "a3"
    t.integer  "a4"
    t.integer  "a5"
    t.integer  "a6"
    t.integer  "a7"
    t.integer  "a8"
    t.integer  "a9"
    t.integer  "a10"
    t.integer  "a11"
    t.integer  "a12"
    t.integer  "a13"
    t.integer  "a14"
    t.integer  "a15"
    t.integer  "research_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "results", ["research_id"], name: "index_results_on_research_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "type_access"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "ccli"
    t.boolean  "cforn"
    t.boolean  "cprod"
    t.boolean  "ccateg"
    t.boolean  "cvend"
    t.boolean  "cuser"
    t.boolean  "mos"
    t.boolean  "fpag"
    t.boolean  "frec"
    t.boolean  "rcli"
    t.boolean  "rforn"
    t.boolean  "rprod"
    t.boolean  "rpag"
    t.boolean  "rrec"
    t.boolean  "rcateg"
    t.boolean  "rvend"
    t.boolean  "mupload"
    t.boolean  "rfecha"
    t.boolean  "minput"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "questions", "categories"
  add_foreign_key "quizzes", "categories"
  add_foreign_key "researches", "categories"
  add_foreign_key "results", "researches"
end
