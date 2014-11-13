require 'spec_helper'

describe TomtomWebfleetConnect::Configuration do

  after do
    TomtomWebfleetConnect.reset
  end

  TomtomWebfleetConnect::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it 'should return the default value' do
        expect(TomtomWebfleetConnect.send(key)).to eq(TomtomWebfleetConnect::Configuration.const_get("DEFAULT_#{key.upcase}"))
      end
    end
  end

  describe '.configure' do
    TomtomWebfleetConnect::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        TomtomWebfleetConnect.configure do |config|
          config.send("#{key}=", key)
          expect(TomtomWebfleetConnect.send(key)).to eq(key)
        end
      end
    end
  end

end