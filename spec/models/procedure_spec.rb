require 'spec_helper'

describe Procedure do
  should_have_column :base_name, :type => :string
  should_have_column :code, :type => :string
  should_have_column :display_order, :type => :integer
  
  should_validate_presence_of :base_name
end
