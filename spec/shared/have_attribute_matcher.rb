defmatcher :have_attribute do
  def initialize(attribute)
    @attribute = attribute
  end
  
  def matches?(target)
    @target = target
    @target.new.attributes.keys.include?(@attribute.to_s)
  end
  
  def failure_message
    "#{@attribute} is NOT an attribute of #{@target}"
  end

  def negative_failure_message
    "#{@attribute} is an attribute of #{@target}"
  end
end
