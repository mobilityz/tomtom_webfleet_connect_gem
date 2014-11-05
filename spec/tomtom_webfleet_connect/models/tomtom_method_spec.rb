require 'spec_helper'

describe TomtomWebfleetConnect::Models::TomtomMethod do
  
  let(:method) { TomtomWebfleetConnect::Models::TomtomMethod.create! name: 'calcRouteSimpleExtern', quota: 6, quota_delay: 1 }
  subject { method }
  
  it(:name) {is_expected.not_to be_nil}
  it(:quota) {is_expected.not_to be_nil}
  it(:quota_delay) {is_expected.not_to be_nil}


  xit 'constant method accessible' do
    expect(TomtomWebfleetConnect::Models::TomtomMethod::METHODS::QUEUE_EXTERN_CREATE[:method]).to eq('createQueueExtern')
  end
  xit 'constant quota accessible' do
    expect(TomtomWebfleetConnect::Models::TomtomMethod::METHODS::QUEUE_EXTERN_CREATE[:quota]).to eq(10)
  end
  xit 'constant quota_delay accessible' do
    expect(TomtomWebfleetConnect::Models::TomtomMethod::METHODS::QUEUE_EXTERN_CREATE[:quota_delay]).to eq(24 * 60)
  end

end