require 'spec_helper'
require 'rspec/its'

describe TomtomWebfleetConnect::Models::MethodCounter do
  
  let(:user) { TomtomWebfleetConnect::Models::User.create! :name => ENV['USER_NAME'], :password => ENV['USER_PASSWORD'] }
  let(:method) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'calcRouteSimpleExtern', quota: 6, quota_delay: 1 }
  let(:method_counter) { TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user.id, tomtom_method_id: method.id }
  subject { method_counter }
  
  its(:user_id) {should_not be_nil}
  its(:tomtom_method_id) {should_not be_nil}
  
  it { should respond_to :counter_can_be_reset? }
  it { should respond_to :reset_counter }
  it { should respond_to :start_counter }
  it { should respond_to :increment_counter }

  it "counter should not be a string" do
    method_counter.counter = "string"
    method_counter.should_not be_valid
  end
  
  it "counter should not be a float" do
    method_counter.counter = 1.3
    method_counter.should_not be_valid
  end

  #DEPRECATED
  xit "search method constant" do
    constant = TomtomWebfleetConnect::Models::MethodCounter.search_method_constant("showVehicleReportExtern")
    constant.second[:method].should == "showVehicleReportExtern"
    constant.second[:quota].should == 10
    constant.second[:quota_delay].should == 1
  end
  
  it "counter should not be a float" do
    method_counter.counter = 1.3
    method_counter.should_not be_valid
  end

  it 'with quota delay exceeded can be reset' do
    method = TomtomWebfleetConnect::Models::TomtomMethod.create! name: "test", quota: 6, quota_delay: 1
    counter = TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user.id, tomtom_method_id: method.id, counter: 2, counter_start_at: DateTime.now - method.quota_delay.minutes - 1.minutes
    expect(counter.counter_can_be_reset?).to eq(true)
  end
  
  it 'with quota delay not exceeded can not be reset' do
    method = TomtomWebfleetConnect::Models::TomtomMethod.create! name: "test", quota: 6, quota_delay: 1
    counter = TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user.id, tomtom_method_id: method.id, counter: 2, counter_start_at: DateTime.now - method.quota_delay.minutes + 1.minutes
    expect(counter.counter_can_be_reset?).to eq(false)
  end

  it 'increment nil counter should place counter at 1 and set start_at at now' do
    method_counter.increment_counter
    method_counter.counter_start_at.should_not be_nil
    expect(method_counter.counter).to eq(1)
  end

  it 'increment not nil counter should increment counter' do
    method_counter.start_counter
    method_counter.increment_counter
    method_counter.counter_start_at.should_not be_nil
    expect(method_counter.counter).to eq(2)
  end

  it 'reset method should place counter and counter_start_at to nil' do
    method = TomtomWebfleetConnect::Models::TomtomMethod.create! name: "test", quota: 6, quota_delay: 1
    counter = TomtomWebfleetConnect::Models::MethodCounter.create! user_id: user.id, tomtom_method_id: method.id, counter: 2, counter_start_at: DateTime.now - method.quota_delay.minutes + 1.minutes
    counter.reset_counter
    method_counter.counter_start_at.should be_nil
    method_counter.counter.should be_nil
  end

end