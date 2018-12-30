require 'json'
require 'dkc/config'

RSpec.describe Dkc::Config do

  it "has an instance method" do
    expect(Dkc::Config.instance).to be_truthy
  end

  context "a config file exists" do
    before :context do
      config_file = File.new(CONFIG_FILE_NAME, "w+")
      config_data = { usesCompose: true }
      config_file.write(config_data.to_json)
      config_file.close
    end

    after :context do
      File.delete(CONFIG_FILE_NAME)
    end

    it "returns true when calling load" do
      expect(Dkc::Config.instance.load).to eql(true)
    end

    it "returns values from config object" do
      expect(Dkc::Config.instance.getValue('usesCompose')).to eql(true)
    end
  end

  context "a config does not exists" do
    it "returns false when calling load" do
      expect(Dkc::Config.instance.load).to eql(false)
    end
  end

  context "a config file exists but is invalid" do
    before :context do
      config_file = File.new(CONFIG_FILE_NAME, "w+")
      config_data = ""
      config_file.write(config_data.to_json)
      config_file.close
    end

    after :context do
      File.delete(CONFIG_FILE_NAME)
    end

    it "returns false when calling load" do
      expect(Dkc::Config.instance.load).to eql(false)
    end
  end

end
