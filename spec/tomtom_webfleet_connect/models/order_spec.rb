require 'spec_helper'
require 'tomtom_webfleet_connect/models/tomtom_object'
require 'tomtom_webfleet_connect/models/address'
require 'tomtom_webfleet_connect/models/tomtom_date'
require 'tomtom_webfleet_connect/models/order_state'

describe TomtomWebfleetConnect::Models::Order do

  let(:client) { TomtomWebfleetConnect::API.new(ENV['API_KEY'], ENV['ACCOUNT'], {lang: 'fr', use_ISO8601: true, use_UTF8: true, response_format: ENV['FORMAT']}) }
  let!(:user) { TomtomWebfleetConnect::Models::User.create! :name => ENV['USER_NAME'], :password => ENV['USER_PASSWORD'] }
  let!(:user2) { TomtomWebfleetConnect::Models::User.create! :name => ENV['USER2_NAME'], :password => ENV['USER2_PASSWORD'] }

  let!(:sendOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'sendOrderExtern', quota: 300, quota_delay: 30 }
  let!(:sendDestinationOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'sendDestinationOrderExtern', quota: 300, quota_delay: 30 }
  let!(:updateOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'updateOrderExtern', quota: 300, quota_delay: 30 }
  let!(:updateDestinationOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'updateDestinationOrderExtern', quota: 300, quota_delay: 30 }
  let!(:insertDestinationOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'insertDestinationOrderExtern', quota: 300, quota_delay: 30 }
  let!(:cancelOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'cancelOrderExtern', quota: 300, quota_delay: 30 }
  let!(:assignOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'assignOrderExtern', quota: 300, quota_delay: 30 }
  let!(:reassignOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'reassignOrderExtern', quota: 300, quota_delay: 30 }
  let!(:deleteOrderExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'deleteOrderExtern', quota: 300, quota_delay: 30 }
  let!(:clearOrdersExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'clearOrdersExtern', quota: 300, quota_delay: 30 }
  let!(:showOrderReportExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'showOrderReportExtern', quota: 6, quota_delay: 1 }

  describe 'Class method' do


  end

  describe 'Order class methods' do

    before do
      @tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})
      @order = TomtomWebfleetConnect::Models::Order.create(client, @tomtom_object, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'Order class methods text test'})
    end

    after do
      client.send_request(TomtomWebfleetConnect::Models::Order.clearOrdersExtern(ENV['GPS-TEST'], true))
    end

    it 'insert order' do

      addresse= TomtomWebfleetConnect::Models::Address.new(client, {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})

      order = TomtomWebfleetConnect::Models::Order.insert(client, @tomtom_object, addresse, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'Order class methods text test'})

      expect(order).to_not be_nil
    end

    it 'get all orders of an object should return 3 orders' do

      3.times do
        TomtomWebfleetConnect::Models::Order.create(
            client, @tomtom_object, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'Order class methods text test'})
      end
      orders = TomtomWebfleetConnect::Models::Order.all_for_object(client, @tomtom_object.objectno)

      expect(orders.size).to eq(3)
    end

    it 'find order by id should not be nil' do
      order = TomtomWebfleetConnect::Models::Order.find_by_id(client, @order.orderid)
      expect(order).not_to be_nil
    end

    it 'find order by id should be nil' do
      order = TomtomWebfleetConnect::Models::Order.find_by_id(client, 'xxx')
      expect(order).to be_nil
    end

    it 'generate_orderid' do
      orderid = TomtomWebfleetConnect::Models::Order.generate_orderid

      expect(orderid.size).to be <= 20
    end

    it 'get all order at today and cancel all not finished or not canceled' do
      addresse = TomtomWebfleetConnect::Models::Address.new(client, {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})

      (0...3).each do |i|
        TomtomWebfleetConnect::Models::Order.create_with_destination(client, @tomtom_object, addresse, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'Order class methods text test'})
      end

      orders= TomtomWebfleetConnect::Models::Order.all(client, {range_pattern: TomtomWebfleetConnect::Models::TomtomDate.new.range_pattern})

      orders.each do |order|
        order.cancel unless (order.state.orderstate == TomtomWebfleetConnect::Models::OrderState::STATES::FINISHED or order.state.orderstate == TomtomWebfleetConnect::Models::OrderState::STATES::CANCELLED)
      end

      orders.each do |order|
        order.refresh
      end

      orders.each do |order|
        expect(order.state.orderstate).to eq(TomtomWebfleetConnect::Models::OrderState::STATES::CANCELLED)
      end

    end

    it 'get all order at tomorrow and cancel all not finished or not canceled' do
      addresse = TomtomWebfleetConnect::Models::Address.new(client, {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})
      tomorrow = TomtomWebfleetConnect::Models::TomtomDate.tomorrow

      (0...3).each do |i|
        TomtomWebfleetConnect::Models::Order.create_with_destination(client, @tomtom_object, addresse, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'Tomorrow order', orderdate: tomorrow.date_for_create, ordertime: tomorrow.time_for_create})
      end

      orders= TomtomWebfleetConnect::Models::Order.all(client, tomorrow.get_range_pattern_full_day)

      orders.each do |order|
        order.cancel unless (order.state.orderstate == TomtomWebfleetConnect::Models::OrderState::STATES::FINISHED or order.state.orderstate == TomtomWebfleetConnect::Models::OrderState::STATES::CANCELLED)
      end

      orders.each do |order|
        order.refresh
      end

      orders.each do |order|
        expect(order.state.orderstate).to eq(TomtomWebfleetConnect::Models::OrderState::STATES::CANCELLED)
      end

    end

  end

  describe 'Tomtom methods' do

    before do
      tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})
      @order = TomtomWebfleetConnect::Models::Order.create(client, tomtom_object, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'Order text test'})

      addresse= TomtomWebfleetConnect::Models::Address.new(client, {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})
      @order_with_destination = TomtomWebfleetConnect::Models::Order.create_with_destination(client, tomtom_object, addresse, {orderid: '003_order_test_gem', ordertext: 'Order text test'})
    end

    after do
      client.send_request(TomtomWebfleetConnect::Models::Order.clearOrdersExtern(ENV['GPS-TEST'], true))
      client.send_request(TomtomWebfleetConnect::Models::Order.clearOrdersExtern(ENV['GPS-TEST2'], true))
    end

    it 'sendOrderExtern' do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'sendOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      response = client.send_request(order.sendOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    it 'sendDestinationOrderExtern' do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'sendOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})
      address = TomtomWebfleetConnect::Models::Address.new(client, {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})
      order.address = address

      response = client.send_request(order.sendDestinationOrderExtern(address.to_hash))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it 'updateOrderExtern' do

      @order.ordertext = 'update order text submitted with sendOrderExtern.'

      response = client.send_request(@order.updateOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it 'updateDestinationOrderExtern' do

      @order_with_destination.ordertext = 'update order text submitted with sendDestinationOrderExtern.'
      @order_with_destination.address = TomtomWebfleetConnect::Models::Address.new(client, {latitude: '48858550', longitude: '2294492', country: 'FR', zip: '75007', city: 'Paris', street: 'Avenue Anatole 5'})

      response = client.send_request(@order_with_destination.updateDestinationOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit 'insertDestinationOrderExtern' do

    end

    it 'cancelOrderExtern' do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'cancelOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      client.send_request(order.sendOrderExtern)
      response = client.send_request(order.cancelOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it 'assignOrderExtern' do
      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'assignOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      client.send_request(order.sendOrderExtern)
      client.send_request(order.cancelOrderExtern)
      response = client.send_request(order.assignOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

      order.delete
    end

    it 'reassignOrderExtern' do
      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'reassignOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      client.send_request(order.sendOrderExtern)
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST2']})
      response = client.send_request(order.reassignOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it 'deleteOrderExtern' do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'deleteOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      client.send_request(order.sendOrderExtern)
      response = client.send_request(order.deleteOrderExtern(true))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it 'clearOrdersExtern' do

      response = client.send_request(TomtomWebfleetConnect::Models::Order.clearOrdersExtern(ENV['GPS-TEST'], true))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it 'showOrderReportExtern (retrieve all orders for the current mouth)' do

      response = client.send_request(TomtomWebfleetConnect::Models::Order.showOrderReportExtern({range_pattern: 'm0'}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq('OK')
      expect(response.response_message).to eq('')
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit 'showOrderWaypoints' do

    end

  end

end
