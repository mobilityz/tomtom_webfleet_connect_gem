require 'spec_helper'

describe TomtomWebfleetConnect::Models::TomtomMethod do
  
  let(:method) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: "calcRouteSimpleExtern", quota: 6, quota_delay: 1 }
  subject { method }
  
  its(:name) {should_not be_nil}
  its(:quota) {should_not be_nil}
  its(:quota_delay) {should_not be_nil}

  xit { should allow_mass_assignment_of(:name) }
  xit { should allow_mass_assignment_of(:quota) }
  xit { should allow_mass_assignment_of(:quota_delay) }


  xit "constant method accessible" do
    TomtomWebfleetConnect::Models::TomtomMethod::METHODS::QUEUE_EXTERN_CREATE[:method].should == 'createQueueExtern'
  end
  xit "constant quota accessible" do
    TomtomWebfleetConnect::Models::TomtomMethod::METHODS::QUEUE_EXTERN_CREATE[:quota].should == 10
  end
  xit "constant quota_delay accessible" do
    TomtomWebfleetConnect::Models::TomtomMethod::METHODS::QUEUE_EXTERN_CREATE[:quota_delay].should == 24 * 60
  end
  
  xit "quota should not be a string" do
    method.quota = "string"
    method.should_not be_valid
  end
  
  xit "quota should not be a float" do
    method.quota = 1.3
    method.should_not be_valid
  end

  
end