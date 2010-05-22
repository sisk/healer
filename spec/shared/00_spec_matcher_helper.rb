# An RSpec matcher helper and spec.
#
# Author:: Nolan Eakins <nolan@eakins.net>
# Copyright:: Public domain
# License:: You are free to use and abuse this in anyway.

# Makes defining RSpec matchers a simpler affair. You still have to provide
# the typical set of methods: initialize, matches?, etc. The one thing you
# do not have to do is define a method to instantiate your matcher.
def defmatcher(name, &code)
  klass = Class.new
  klass.module_eval(&code)
  
  Object.send :define_method, name.to_s do |*args|
    klass.new(*args)
  end
end

if __FILE__ == $0
  require 'spec'
  
  defmatcher :test_matcher do
    attr_accessor :expecting, :target
    
    def initialize(expecting)  #:nodoc:all
      @expecting = expecting
    end
    
    def matches?(target) #:nodoc:all
      @target = target
    end
    
    def failure_message  #:nodoc:all
    end
    
    def negative_failure_message  #:nodoc:all
    end
  end

  describe 'defmatcher', 'for TestMatcher' do
    before(:each) do
      @matcher = test_matcher(1)
    end
    
    it 'creates a method called test_matcher that returns your matcher' do
      @matcher.should respond_to(:matches?)
    end
    
    it 'creates a matcher that responds to all of the methods you defined' do
      %W(matches? failure_message negative_failure_message).each do |meth|
        @matcher.should respond_to(meth)
      end
    end
    
    it 'passes along any arguments' do
      @matcher.expecting.should == 1
    end
  end
end
