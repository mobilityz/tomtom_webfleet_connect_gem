ActiveRecord::Schema.define do

  create_table 'tomtom_webfleet_connect_users', :force => true do |t|
    t.string 'name', :null => false
    t.string 'password', :null => false

    t.timestamps  null: false
  end
  
  create_table 'tomtom_webfleet_connect_method_counters', :force => true do |t|
    t.integer 'user_id', :null => false
    t.integer 'tomtom_method_id', :null => false
    t.integer 'counter'
    t.datetime 'counter_start_at'

    t.timestamps  null: false
  end

  create_table 'tomtom_webfleet_connect_methods', :force => true do |t|
      t.string 'name', :null => false
      t.integer 'quota', :null => false
      t.integer 'quota_delay', :null => false

      t.timestamps  null: false
  end
  
end
