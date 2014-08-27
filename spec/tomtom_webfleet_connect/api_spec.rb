require 'spec_helper'
require 'tomtom_webfleet_connect/api'

describe TomtomWebfleetConnect::API do
  
  let!(:user) { TomtomWebfleetConnect::Models::User.create! :name => ENV["USER_NAME"], :password => ENV["USER_PASSWORD"] }
  let!(:user2) { TomtomWebfleetConnect::Models::User.create! :name => ENV["USER2_NAME"], :password => ENV["USER2_PASSWORD"] }

  let!(:calcRouteSimpleExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "calcRouteSimpleExtern", quota: 6, quota_delay: 1 }
  let!(:createQueueExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "createQueueExtern", quota: 10, quota_delay: 24 * 60 }

  let(:client) { TomtomWebfleetConnect::API.new(ENV["API_KEY"], ENV["ACCOUNT"], {lang: "fr", use_ISO8601: true, use_UTF8: true})}

  before do
    @account = ENV["ACCOUNT"]
    @api_key = ENV["API_KEY"]
    @root_url = "https://csv.business.tomtom.com/extern"
    @lang = ENV["LANG"]
    @use_ISO8601 = "true"
    @use_UTF8 = "true"
  end
  
  describe "attributes" do
    
    before do
      @tomtom_webfleet_connect = TomtomWebfleetConnect::API.new
    end
    
    it "have no API by default" do
      expect(@tomtom_webfleet_connect.key).to be_nil
    end
    
    it "have no account by default" do
      expect(@tomtom_webfleet_connect.account).to be_nil
    end
    
    it "set an API key and account in constructor" do
      tomtom_webfleet_connect = TomtomWebfleetConnect::API.new(@api_key, @account)
      expect(tomtom_webfleet_connect.key).to eq(@api_key)
      expect(tomtom_webfleet_connect.account).to eq(@account)
    end
    
    it "set an API key via setter" do
      @tomtom_webfleet_connect.key = @api_key
      expect(@tomtom_webfleet_connect.key).to eq(@api_key)
    end
    
    it "set an account via setter" do
      @tomtom_webfleet_connect.account = @account
      expect(@tomtom_webfleet_connect.account).to eq(@account)
    end
    
    it "set lang and get" do
      @tomtom_webfleet_connect.lang = @lang
      expect(@tomtom_webfleet_connect.lang).to eq(@lang)
    end
    
    it "set use_ISO8601 and get" do
      @tomtom_webfleet_connect.use_ISO8601 = @use_ISO8601
      expect(@tomtom_webfleet_connect.use_ISO8601).to eq(@use_ISO8601)
    end
    
    it "set use_UTF8 and get" do
      @tomtom_webfleet_connect.use_UTF8 = @use_UTF8
      expect(@tomtom_webfleet_connect.use_UTF8).to eq(@use_UTF8)
    end
  end
  
  describe "method" do

    before do
      @parameters_url = @root_url + "?" + "account=#{@account}" + "&apikey=#{@api_key}" + "&lang=#{@lang}" + "&useISO8601=#{@use_ISO8601}" + "&useUTF8=#{@use_UTF8}"
      @base_url = @parameters_url + "&username=" + ENV["USER_NAME"] + "&password=" + ENV["USER_PASSWORD"]
      @createQueueExtern_url = @base_url + "&action=createQueueExtern"

    end

    before(:each) do
      TomtomWebfleetConnect::Models::TomtomMethod.where(['id not in (?)', [1,2]]).delete_all
      TomtomWebfleetConnect::Models::User.where(['id not in (?)', [1,2]]).delete_all
      TomtomWebfleetConnect::Models::MethodCounter.where(['user_id not in (?)', [1,2]]).delete_all
    end

    it "get root API url" do
      expect(client.get_root_url).to eq(@root_url)
    end
    
    it "get API url with parameters" do
      expect(client.get_url_with_parameters).to eq(@parameters_url)
    end
    
    it "get base_url with new user" do
      expect(client.get_base_url(user)).to eq(@base_url)
    end

    it "get method url" do
      expect(client.get_method_url(createQueueExtern, user)).to eq(@createQueueExtern_url)
    end

    it "with action return empty response" do
      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "insertDriverExtern", quota:10, quota_delay: 1
      response = client.send_request(
        {action: 'insertDriverExtern',
        driverno: "r-" + rand(99999).to_s,
        name: "rspec" + "%20" + "rspec",
        country: "FR",
        zip: 59000,
        city: "Lille",
        street: "zzkkzk",
        telmobile: "06060660606",
        email: "driver@email.com",
        code: rand(99999),
        pin: "5959"}
      )
      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    it "with action return one line" do

      response = client.estimate_route(Date.today, 50.6293465, 3.05707680, 50.637528, 3.070923)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
      response.response_body.should_not be_nil
    end

    it "with action return array" do
      TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showNearestVehicles", quota:10, quota_delay: 1
      response = client.send_request({action: 'showNearestVehicles', priority: 2, latitude: 3070923, longitude: 3070923})
      expect(response.response_body).to be_an(Array)
    end



    describe "quota manager" do

      it "should exceeds quota" do
        #encoder le mot de passe http://meyerweb.com/eric/tools/dencoder/
        method = TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showObjectReportExtern", quota: 6, quota_delay: 1
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user.id, tomtom_method_id: method.id
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user2.id, tomtom_method_id: method.id

        puts TomtomWebfleetConnect::Models::User.all

        (0..13).each do |i|
          puts "------ essai #{i} ------"
          response = client.send_request({action: 'showObjectReportExtern', filterstring: "GPS-TEST-1"})
          if i >= 12
            expect(response.http_status_code).to eq(200)
            expect(response.http_status_message).to eq("OK")
            expect(response.response_message).to eq("request quota reached")
            expect(response.response_code).to eq(8011)
            expect(response.error).to eq(true)
            expect(response.success).to eq(false)
          else
            expect(response.http_status_code).to eq(200)
            expect(response.http_status_message).to eq("OK")
            expect(response.response_message).to eq("")
            expect(response.response_code).to eq(nil)
            expect(response.error).to eq(false)
            expect(response.success).to eq(true)
          end
        end
      end

      it "should not exceeds quota" do
        #encoder le mot de passe http://meyerweb.com/eric/tools/dencoder/
        #method = TomtomWebfleetConnect::Models::TomtomMethod.create! name: "calcRouteSimpleExtern", quota: 6, quota_delay: 1
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user.id, tomtom_method_id: calcRouteSimpleExtern.id
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user2.id, tomtom_method_id: calcRouteSimpleExtern.id

        (0..10).each do |i|
          puts "------ essai #{i} ------"
          response = client.send_request({action: 'calcRouteSimpleExtern',
            use_traffic: 0,
            start_day: "sun",
            start_time: "05:30:00",
            start_latitude: "50630447",
            start_longitude: "3056340",
            end_latitude: "50735327",
            end_longitude: "3077132"}
          )
          expect(response.http_status_code).to eq(200)
          expect(response.http_status_message).to eq("OK")
          expect(response.response_message).to eq("")
          expect(response.response_code).to eq(nil)
          expect(response.error).to eq(false)
          expect(response.success).to eq(true)
        end
      end

    end
    
  end
  
end