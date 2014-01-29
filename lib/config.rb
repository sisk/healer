require "yaml"

module Healer
  class Config
    class << self

      def anatomy
        config_yaml.anatomy
      end

      def implants
        config_yaml.implants
      end

      def operation
        config_yaml.operation
      end

      def reset!
        v = "@config_yaml"
        remove_instance_variable(v) if instance_variable_defined?(v)
      end


      private ##################################################################

      def config_yaml
        return @config_yaml if @config_yaml

        config_yaml = YAML.load_file("config/healer.yml")
        @config_yaml = Hashie::Mash.new(config_yaml) rescue {};
      end
    end

  end
end