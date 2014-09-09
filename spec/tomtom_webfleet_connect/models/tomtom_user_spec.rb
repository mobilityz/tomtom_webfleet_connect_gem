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

    xit 'Show users' do

      response = client.send_request(TomtomWebfleetConnect::Models::TomtomUser.show_users({username_filter: ENV['USER_TEST_NAME']}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'Change password' do

      response = client.send_request(TomtomWebfleetConnect::Models::TomtomUser.change_password({oldpassword: ENV['USER_PASSWORD'], newpassword: 'testgem'}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'Insert user' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client, {username: 'UserName-Test-Gem',
                                                          realname: 'RealName-Test-Gem',
                                                          email: ENV['EMAIL-TEST'],
                                                          profile: TomtomWebfleetConnect::Models::TomtomUser::PROFILES::ADMIN,
                                                          new_password: 'azerty?59',
                                                          info: 'Create by tomtom gem',
                                                          company: 'TestCompany'})

      response = client.send_request(user.insert_user)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'Update user' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client,{username: 'UserName-Test-Gem'})

      response = client.send_request(user.update_user({realname: 'NewNameUpdate'}))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'Delete user' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client,{username: 'UserName-Test-Gem'})

      response = client.send_request(user.delete_user)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'Get user rights' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client,{username: 'UserName-Test-Gem'})

      response = client.send_request(user.get_user_rights)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'set user right' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client,{username: 'UserName-Test-Gem'})

      response = client.send_request(user.set_user_right(TomtomWebfleetConnect::Models::TomtomUser::UserRight::RIGHT_LEVELS::EXTERNAL_ACCESS))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'reset user rights' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client,{username: 'UserName-Test-Gem'})

      response = client.send_request(user.reset_user_rights)

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

    xit 'remove user right' do

      user= TomtomWebfleetConnect::Models::TomtomUser.new(client,{username: 'UserName-Test-Gem'})

      response = client.send_request(user.remove_user_right(TomtomWebfleetConnect::Models::TomtomUser::UserRight::RIGHT_LEVELS::EXTERNAL_ACCESS))

      expect(response.http_status_code).to eq(200)
      expect(response.http_status_message).to eq("OK")
      expect(response.response_message).to eq("")
      expect(response.response_code).to eq(nil)
      expect(response.error).to eq(false)
      expect(response.success).to eq(true)
    end

  end

end
