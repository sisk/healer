#
# Creates a Matcher that can be used to check if a controller is using a
# specified layout.
#
# Ex: controller.should use_layout('fruity')
#     controller.should_not use_layout('goth')
#
defmatcher :use_layout do
  def initialize(expected)
    @expected = expected
  end
  
  def matches?(target)
    @target = target
    @target.class.instance_variable_get('@inheritable_attributes')['layout'] == @expected
  end
  
  def failure_message
    "expected #{target_name} to use the #{expected_name} layout"
  end
  
  def negative_failure_message
    "expected #{target_name} to use a layout other than the #{expected_name} layout"
  end
  
  protected
  
  def target_name
    @target.controller_name
  end
  
  def expected_name
    @expected ? @expected : 'nil'
  end
end
