require 'spec_helper'

describe TomtomWebfleetConnect::Models::User do
  
  let(:user) { TomtomWebfleetConnect::Models::User.create! :name => ENV['USER_NAME'], :password => ENV['USER_PASSWORD'] }
  subject { user }

  let(:user_with_counter) { TomtomWebfleetConnect::Models::User.create! :name => ENV['USER2_NAME'], :password => ENV['USER2_PASSWORD'] }
  let(:method) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'calcRouteSimpleExtern', quota: 6, quota_delay: 1 }
  let(:method_counter) { TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user_with_counter.id, tomtom_method_id: method.id }
  
  let(:user_with_started_counter) { TomtomWebfleetConnect::Models::User.create! :name => ENV['USER3_NAME'], :password => ENV['USER3_PASSWORD'] }
  let(:method2) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'createQueueExtern', quota: 10, quota_delay: 24 * 60 }
  let(:started_method_counter) { TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user_with_started_counter.id, tomtom_method_id: method2.id }

  let(:client) {
    TomtomWebfleetConnect.configure do |config|
      config.api_key = ENV['API_KEY']
      config.account = ENV['ACCOUNT']
      config.lang = ENV['LANG']
      config.user = ENV['USER_NAME']
      config.mdp = ENV['USER_PASSWORD']
    end
    TomtomWebfleetConnect::Client.new
  }
  
  its(:name) {is_expected.not_to be_nil}
  its(:password) {is_expected.not_to be_nil}
  it {is_expected.to be_valid}


  describe 'with invalid attributes' do
    it 'name should not be nil' do
      user = TomtomWebfleetConnect::Models::User.create(password: 'test')
      expect(user).not_to be_valid
    end
    
    it 'password should not be nil' do
      user = TomtomWebfleetConnect::Models::User.create(name: 'test')
      expect(user).not_to be_valid
    end
  end

  describe 'for scope available_users' do
    it 'without method_counter should be available' do
      available_users = TomtomWebfleetConnect::Models::User.avalaible_user(method)
      expect(available_users).to include(user)
    end

    describe 'with method_counter' do
      it 'with quota and started_counter null should be available' do
        user1 = TomtomWebfleetConnect::Models::User.create! :name => ENV['USER3_NAME'], :password => ENV['USER3_PASSWORD']
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user1.id, tomtom_method_id: method2.id
        available_users = TomtomWebfleetConnect::Models::User.avalaible_user(method2)
        expect(available_users).to include(user1)
      end

      it 'with quota less than max should be available' do
        user2 = TomtomWebfleetConnect::Models::User.create! :name => ENV['USER3_NAME'], :password => ENV['USER3_PASSWORD']
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user2.id, tomtom_method_id: method2.id, counter: 8, counter_start_at: DateTime.now
        available_users = TomtomWebfleetConnect::Models::User.avalaible_user(method2)
        expect(available_users).to include(user2)
      end

      it 'with counter greater than quota max and not exceeded delay should not be available' do
        user3 = TomtomWebfleetConnect::Models::User.create! :name => ENV['USER4_NAME'], :password => ENV['USER4_PASSWORD']
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user3.id, tomtom_method_id: method2.id, counter: 10, counter_start_at: DateTime.now
        available_users = TomtomWebfleetConnect::Models::User.avalaible_user(method2)
        expect(available_users).not_to include(user3)
      end

      it 'with counter greater than quota max and exceeded delay should be available' do
        user4 = TomtomWebfleetConnect::Models::User.create! :name => ENV['USER5_NAME'], :password => ENV['USER5_PASSWORD']
        TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user4.id, tomtom_method_id: method2.id, counter: 10, counter_start_at: DateTime.now - (24*60 + 1).minutes
        available_users = TomtomWebfleetConnect::Models::User.avalaible_user(method2)
        expect(available_users).to include(user4)
      end

    end
  end

end