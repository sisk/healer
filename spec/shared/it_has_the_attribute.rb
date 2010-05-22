#
# Specifies that the model under test has an AR attribute of a specified type.
# It can also specify a few other things via an options hash:
#
#   options:
#     :type => symbol for the type, ie: :integer
#     :required => true if this attribute has a validates_presence_of
#
# You can also pass in a block to further specify the attribute. If for some
# reason the model's class can not be inferred, setting @klass in a before(:all)
# should cause the attribute specification to use that class.
#
def column_for(klass, attribute)
  klass.new.column_for_attribute(attribute)
end

def it_has_the_attribute(attribute, options = Hash.new, &block)
  name = "\##{attribute}"
  type = options[:type]
  required = options[:required]
  default = options[:default]

  klass = const_get(description)
  
  describe name do
    before(:all) do
      @klass ||= klass
    end
    
    it "is an attribute" do
      @klass.should have_attribute(attribute)
    end
    
    it "has a writer" do
      @klass.new.should respond_to("#{attribute}=")
    end
    
    it "has a reader" do
      @klass.new.should respond_to(attribute)
    end

    if options[:type]
      it "is a #{type}" do
        column_for(@klass, attribute).type.should == type
      end
    end

    if options[:required]
      it "is required to be valid" do
        instance = @klass.new
        instance.send("#{attribute}=", nil)
        instance.should have_at_least(1).error_on(attribute)
      end
    end
    
    if options[:default]
      it "defaults to #{options[:default]}" do
        column_for(@klass, attribute).default.should == options[:default]
      end
    end
    
    if options[:primary]
      it "is a primary key" do
        column_for(@klass, attribute).primary.should == options[:primary]
      end
    end
    
    if options[:precision]
      it "has the precision of #{options[:precision]}" do
        column_for(@klass, attribute).precision.should == options[:precision]
      end
    end
    
    if options[:limit]
      it "is limited to #{options[:limit]}" do
        column_for(@klass, attribute).limit.should == options[:limit]
      end
    end
    
    if options[:null] == true
      it "allows null values" do
        column_for(@klass, attribute).null.should == true
      end
    elsif options[:null] == false
      it "disallows null values" do
        column_for(@klass, attribute).null.should == false
      end
    end
    
    if options[:scale]
      it "is scaled by #{options[:scale]}" do
        column_for(@klass, attribute).scale.should == options[:scale]
      end
    end
  end

  describe name, &block if block_given?
end
