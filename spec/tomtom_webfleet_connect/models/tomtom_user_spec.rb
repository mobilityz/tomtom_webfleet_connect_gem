require 'spec_helper'
require 'tomtom_webfleet_connect/models/tomtom_user'

describe TomtomWebfleetConnect::Models::TomtomUser do

  let(:client) { TomtomWebfleetConnect::API.new(ENV['API_KEY'], ENV['ACCOUNT'], {lang: "fr", use_ISO8601: true, use_UTF8: true}, TomtomWebfleetConnect::TomtomResponse::FORMATS::CSV) }
  let!(:user) { TomtomWebfleetConnect::Models::User.create! :name => ENV["USER_NAME"], :password => ENV["USER_PASSWORD"] }
  let!(:user2) { TomtomWebfleetConnect::Models::User.create! :name => ENV["USER2_NAME"], :password => ENV["USER2_PASSWORD"] }

  let!(:senduserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showUsers", quota: 10, quota_delay: 1 }
  let!(:sendDestinationuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "changePassword", quota: 10, quota_delay: 60 }
  let!(:updateuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "insertUser", quota: 10, quota_delay: 1 }
  let!(:updateDestinationuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "updateUser", quota: 10, quota_delay: 1 }
  let!(:insertDestinationuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "deleteUser", quota: 10, quota_delay: 1 }
  let!(:canceluserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "getUserRights", quota: 10, quota_delay: 1 }
  let!(:assignuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "setUserRight", quota: 10, quota_delay: 1 }
  let!(:reassignuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "resetUserRights", quota: 10, quota_delay: 1 }
  let!(:deleteuserExtern) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "removeUserRight", quota: 10, quota_delay: 1 }

  describe "Class method" do


  end

  describe "User class methods" do

    # before do
    #
    # end
    #
    # after do
    #
    # end


  end

  describe "Tomtom methods" do

    it 'Show users' do

      response = client.send_request(TomtomWebfleetConnect::Models::TomtomUser.show_users({username: 'api'}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'Change password' do

      response = client.send_request(TomtomWebfleetConnect::Models::TomtomUser.change_password({oldpassword: '', newpassword: ''}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    it 'Insert user' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client)

      response = client.send_request(user.insert_user)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    # it '' do
    #
    #   user= TomtomWebfleetConnect::Models::TomtomUser
    #
    #   response = client.send_request(user.)
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    # end
    #
    # it '' do
    #
    #   user= TomtomWebfleetConnect::Models::TomtomUser
    #
    #   response = client.send_request(user.)
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    # end
    #
    # it '' do
    #
    #   user= TomtomWebfleetConnect::Models::TomtomUser
    #
    #   response = client.send_request(user.)
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    # end
    #
    # it '' do
    #
    #   user= TomtomWebfleetConnect::Models::TomtomUser
    #
    #   response = client.send_request(user.)
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    # end
    #
    # it '' do
    #
    #   user= TomtomWebfleetConnect::Models::TomtomUser
    #
    #   response = client.send_request(user.)
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    # end
    #
    # it '' do
    #
    #   user= TomtomWebfleetConnect::Models::TomtomUser
    #
    #   response = client.send_request(user.)
    #
    #   expect(response.http_status_code).to eq(200)
    #   expect(response.http_status_message).to eq("OK")
    #   expect(response.response_message).to eq("")
    #   expect(response.response_code).to eq(nil)
    #   expect(response.error).to eq(false)
    #   expect(response.success).to eq(true)
    # end

  end

end
