require 'spec_helper'
require 'tomtom_webfleet_connect/models/tomtom_object'
require 'tomtom_webfleet_connect/models/addresse'

describe TomtomWebfleetConnect::Models::Order do

  let(:client) { TomtomWebfleetConnect::API.new(ENV['API_KEY'], ENV['ACCOUNT'], {lang: "fr", use_ISO8601: true, use_UTF8: true})}
  let!(:user) { TomtomWebfleetConnect::Models::User.create! :name => ENV["USER_NAME"], :password => ENV["USER_PASSWORD"] }
  let!(:user2) { TomtomWebfleetConnect::Models::User.create! :name => ENV["USER2_NAME"], :password => ENV["USER2_PASSWORD"] }

  describe "Class method" do

    # xit "create" do
    #
    #   order, response = TomtomWebfleetConnect::Models::Order.create(client, ENV['GPS-TEST'], '001_order_test_gem', 'Order text test')
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    #
    #   expect(order).not_to be_nil
    # end

    # it "create an existing one" do
    #   response = TomtomWebfleetConnect::Models::Order.create(client, ENV['GPS-TEST'], orderid, 'Order text test')
    #
    #   response = TomtomWebfleetConnect::Models::Order.create(client, ENV['GPS-TEST'], orderid, 'Order text test')
    #
    #   puts response
    # end

    # it "all_for_object" do
    #
    #   response = TomtomWebfleetConnect::Models::Order.all_for_object(client, ENV['GPS-TEST'])
    #
    #   puts response
    # end

  end

  describe "Order class methods" do

    before do
      tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})
      @order = TomtomWebfleetConnect::Models::Order.create(client, tomtom_object, {orderid: '001_order_test_gem', ordertext: 'Order class methods text test'})
      # @order_with_destination = TomtomWebfleetConnect::Models::Order.create_with_destination(client, ENV['GPS-TEST'], '002_order_test_gem', 'Order text test', {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})
    end

    after do
      @order.delete
    end

    xit "all_for_object" do
      orders= TomtomWebfleetConnect::Models::Order.all_for_object(client, ENV['GPS-TEST'])

      expect(orders.size).to be >= 1
    end

    it "find_with_id" do
      order= TomtomWebfleetConnect::Models::Order.find_with_id(client, @order.orderid)

      expect(order).to_not be_nil
    end

    it "generate_orderid" do
      orderid= TomtomWebfleetConnect::Models::Order.generate_orderid

      expect(orderid.size).to be <= 20
    end

  end

  describe "Tomtom methods" do

    before do
      tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})
      @order = TomtomWebfleetConnect::Models::Order.create(client, tomtom_object, {orderid: '001_order_test_gem', ordertext: 'Order text test'})

      addresse= TomtomWebfleetConnect::Models::Addresse.new(client, {latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'})
      @order_with_destination = TomtomWebfleetConnect::Models::Order.create_with_destination(client, tomtom_object, addresse ,{orderid: '001_order_test_gem', ordertext: 'Order text test'})
    end

    after do
      @order.delete
      @order_with_destination.delete
    end

    it "sendOrderExtern" do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'sendOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendOrderExtern", quota:300, quota_delay: 30
      response = client.send_request(order.sendOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    it "sendDestinationOrderExtern" do

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendDestinationOrderExtern", quota:300, quota_delay: 30
      response = client.send_request(@order.sendDestinationOrderExtern({latitude: '51365338', longitude: '12398799', country: 'DE', zip: '04129', city: 'Leipzig', street: 'Maximilianallee 4'}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it "updateOrderExtern" do

      @order.message = "update order text submitted with sendOrderExtern."

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "updateOrderExtern", quota:300, quota_delay: 30
      response = client.send_request(@order.updateOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    it "updateDestinationOrderExtern" do

      @order_with_destination.message = "update order text submitted with sendDestinationOrderExtern."
      @order_with_destination.destination.adresse = TomtomWebfleetConnect::Models::Addresse.new({latitude: '48858550', longitude: '2294492', country: 'FR', zip: '75007', city: 'Paris', street: 'Avenue Anatole 5'})

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "updateDestinationOrderExtern", quota:300, quota_delay: 30
      response = client.send_request(@order_with_destination.updateDestinationOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit "insertDestinationOrderExtern" do

    end

    xit "cancelOrderExtern" do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'cancelOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendOrderExtern", quota:300, quota_delay: 30
      client.send_request(order.sendOrderExtern)

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "cancelOrderExtern", quota:300, quota_delay: 30
      response = client.send_request(order.cancelOrderExtern)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit "assignOrderExtern" do

    end

    xit "reassignOrderExtern" do

    end

    xit "deleteOrderExtern" do

      order= TomtomWebfleetConnect::Models::Order.new(client, {orderid: TomtomWebfleetConnect::Models::Order.generate_orderid, ordertext: 'deleteOrderExtern test'})
      order.tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(client, {objectno: ENV['GPS-TEST']})

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendOrderExtern", quota:300, quota_delay: 30
      client.send_request(order.sendOrderExtern)

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "deleteOrderExtern", quota:300, quota_delay: 30
      response = client.send_request(order.deleteOrderExtern(true))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit "clearOrdersExtern" do

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "clearOrdersExtern", quota:300, quota_delay: 30
      response = client.send_request(TomtomWebfleetConnect::Models::Order.clearOrdersExtern(ENV['GPS-TEST'] ,true))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit "showOrderReportExtern (retrieve all orders for the current mouth)" do

      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showOrderReportExtern", quota:6, quota_delay: 1
      response = client.send_request(TomtomWebfleetConnect::Models::Order.showOrderReportExtern({range_pattern: 'm0'}))

      puts response

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)

    end

    xit "showOrderWaypoints" do

    end

  end

end
