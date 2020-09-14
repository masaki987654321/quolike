class CreateAllTable < ActiveRecord::Migration[5.1]
  def change
    create_table "answers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.text "content"
      t.bigint "user_id"
      t.bigint "question_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  
    create_table "questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.text "content"
      t.bigint "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "best_answer_id"
    end
    
    create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "email"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "password_digest"
      t.string "remember_digest"
      t.boolean "admin", default: false
    end
  
    add_foreign_key "answers", "questions"
    add_foreign_key "answers", "users"
    add_foreign_key "questions", "users"
  end
end
