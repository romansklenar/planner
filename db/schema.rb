# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100505041925) do

  create_table "bugs", :force => true do |t|
    t.string   "name",                                :null => false
    t.integer  "actual_user_id"
    t.boolean  "approved",         :default => false, :null => false
    t.datetime "approved_at"
    t.boolean  "closed",           :default => false, :null => false
    t.boolean  "closed_at"
    t.text     "description",                         :null => false
    t.text     "note"
    t.integer  "proposed_user_id"
    t.string   "reported_by",                         :null => false
    t.integer  "task_id"
    t.integer  "position"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bugs", ["name"], :name => "index_bugs_on_name"
  add_index "bugs", ["position"], :name => "index_bugs_on_position"
  add_index "bugs", ["task_id"], :name => "index_bugs_on_task_id"

  create_table "grants", :force => true do |t|
    t.string   "name",                                                      :null => false
    t.decimal  "budget",     :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grants", ["name"], :name => "index_grants_on_name", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "tasklists", :force => true do |t|
    t.string   "name",                               :null => false
    t.integer  "user_id",                            :null => false
    t.string   "kind",         :default => "P",      :null => false
    t.string   "state",        :default => "active", :null => false
    t.text     "description"
    t.text     "note"
    t.float    "budget_hours"
    t.integer  "grant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasklists", ["grant_id"], :name => "index_tasklists_on_grant_id"
  add_index "tasklists", ["kind"], :name => "index_tasklists_on_kind"
  add_index "tasklists", ["name"], :name => "index_tasklists_on_name"
  add_index "tasklists", ["state"], :name => "index_tasklists_on_state"
  add_index "tasklists", ["user_id"], :name => "index_tasklists_on_user_id"

  create_table "tasks", :force => true do |t|
    t.integer  "project_id"
    t.string   "name",                                 :null => false
    t.boolean  "completed",         :default => false, :null => false
    t.boolean  "checked",           :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "completed_at"
    t.datetime "checked_at"
    t.date     "due_to"
    t.date     "scheduled_to"
    t.string   "state"
    t.integer  "delegated_user_id"
    t.text     "description"
    t.text     "note"
    t.integer  "tasklist_id"
    t.integer  "worktype_id"
    t.integer  "priority",          :default => 1,     :null => false
  end

  add_index "tasks", ["name"], :name => "index_tasks_on_name"
  add_index "tasks", ["position"], :name => "index_tasks_on_position"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["state"], :name => "index_tasks_on_state"
  add_index "tasks", ["tasklist_id"], :name => "index_tasks_on_tasklist_id"
  add_index "tasks", ["worktype_id"], :name => "index_tasks_on_worktype_id"

  create_table "timesheets", :force => true do |t|
    t.integer  "task_id",     :null => false
    t.integer  "user_id",     :null => false
    t.datetime "started_at",  :null => false
    t.datetime "finished_at", :null => false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timesheets", ["task_id"], :name => "index_timesheets_on_task_id"
  add_index "timesheets", ["user_id"], :name => "index_timesheets_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",              :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "worktypes", :force => true do |t|
    t.string   "name",                                                          :null => false
    t.decimal  "price_per_hour", :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "worktypes", ["name"], :name => "index_worktypes_on_name", :unique => true

end
