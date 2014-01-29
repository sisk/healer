require "spec_helper"
require "config"

describe Healer::Config do

  describe ".anatomy" do
    before(:each) do
      Healer::Config.reset!

      config_yaml = <<-EOF
      anatomy:
        something: "with a value"
        something_else: [5, 6, 7]
      EOF

      YAML.stub(:load_file).with("config/healer.yml")
        .and_return(YAML.load(config_yaml))
    end

    it "returns valyes from yml" do
      Healer::Config.anatomy[:something].should == "with a value"
      Healer::Config.anatomy[:something_else].should == [5, 6, 7]
    end
  end

  describe ".implants" do
    before(:each) do
      Healer::Config.reset!

      config_yaml = <<-EOF
      implants:
        something: "with another value"
        something_else: [5, 6, 7, 8]
      EOF

      YAML.stub(:load_file).with("config/healer.yml")
        .and_return(YAML.load(config_yaml))
    end

    it "returns valyes from yml" do
      Healer::Config.implants[:something].should == "with another value"
      Healer::Config.implants[:something_else].should == [5, 6, 7, 8]
    end
  end

  describe ".operation" do
    before(:each) do
      Healer::Config.reset!

      config_yaml = <<-EOF
      operation:
        something: "with another value"
        something_else: [5, 6, 7, 8]
      EOF

      YAML.stub(:load_file).with("config/healer.yml")
        .and_return(YAML.load(config_yaml))
    end

    it "returns valyes from yml" do
      Healer::Config.operation[:something].should == "with another value"
      Healer::Config.operation[:something_else].should == [5, 6, 7, 8]
    end
  end
end