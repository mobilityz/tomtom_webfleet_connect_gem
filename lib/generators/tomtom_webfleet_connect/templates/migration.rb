class CreateTomtomWebfleetConnectTables < ActiveRecord::Migration

  def self.up
    create_table :tomtom_webfleet_connect_users, :force => true do |t|
      t.string   :name,                 :null => false
      t.string   :password,             :null => false

      t.timestamps
    end
    
    create_table :tomtom_webfleet_connect_method_counters, :force => true do |t|
      t.integer  :user_id,             :null => false
      t.integer  :tomtom_method_id,    :null => false
      t.integer  :counter
      t.datetime :counter_start_at        

      t.timestamps
    end

    create_table :tomtom_webfleet_connect_methods, :force => true do |t|
      t.string   :name,               :null => false
      t.integer  :quota,              :null => false
      t.integer  :quota_delay,        :null => false

      t.timestamps
    end

    # Message queues
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'createQueueExtern', quota: 10, quota_delay: 1440
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'deleteQueueExtern', quota: 10, quota_delay: 1440
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'popQueueMessagesExtern', quota: 10, quota_delay: 1
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'ackQueueMessagesExtern', quota: 10, quota_delay: 1
    # Objects
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'showObjectReportExtern', quota: 6, quota_delay: 1
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'showVehicleReportExtern', quota: 10, quota_delay: 1
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'showNearestVehicles', quota: 10, quota_delay: 1
    # Orders
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'sendOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'sendDestinationOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'updateOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'updateDestinationOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'insertDestinationOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'cancelOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'assignOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'reassignOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'deleteOrderExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'clearOrdersExtern', quota: 300, quota_delay: 30
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'showOrderReportExtern', quota: 6, quota_delay: 1
    # Drivers
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'showDriverReportExtern', quota: 10, quota_delay: 1
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'insertDriverExtern', quota: 10, quota_delay: 1
    # Geocoding and routing
    TomtomWebfleetConnect::Models::TomtomMethod.create name: 'calcRouteSimpleExtern', quota: 6, quota_delay: 1

    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('createQueueExtern', 10, 24 * 60, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('deleteQueueExtern', 10, 24 * 60, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('popQueueMessagesExtern', 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('ackQueueMessagesExtern', 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")

    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('showObjectReportExtern', 6, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('showVehicleReportExtern', 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('showNearestVehicles', 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")

    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('sendDestinationOrderExtern', 300, 30, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('insertDestinationOrderExtern', 300, 30, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('assignOrderExtern', 300, 30, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('deleteOrderExtern', 300, 30, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('showOrderReportExtern', 6, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")

    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('showDriverReportExtern', 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('insertDriverExtern', 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")

    # execute ("insert into tomtom_webfleet_connect_methods (name, quota, quota_delay, created_at, updated_at) values ('calcRouteSimpleExtern', 6, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")

  end
  
  def self.down
    drop_table :tomtom_webfleet_connect_users
    drop_table :tomtom_webfleet_connect_method_counters
    drop_table :tomtom_webfleet_connect_methods
  end
  
end