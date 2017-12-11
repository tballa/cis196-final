ActiveRecord::Schema.define(version: 20171203170518) do
  create_table 'messages', force: :cascade do |t|
    t.text 'text'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_messages_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'password_hash'
    t.string 'target'
    t.boolean 'active'
    t.boolean 'admin'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
