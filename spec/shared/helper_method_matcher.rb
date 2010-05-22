#
# Creates a Matcher that can be used to check if a controller is using the
# named helper method.
#
# Ex: controller.should have_helper('fruity')
#     controller.should_not have_helper('goth')
#
defmatcher :have_helper do
  def initialize(expected)
    @expected = expected
  end
  
  def matches?(target)
    @target = target
    @target.master_helper_module.instance_methods.include? @expected.to_s
  end
  
  def failure_message
    "expected #{@target} to have a helper method named #{@expected}"
  end
  
  def negative_failure_message
    "#{@target} has a helper method named #{@expected}"
  end
end
