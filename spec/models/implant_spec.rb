require 'spec_helper'

describe Implant do
  should_have_column :type, :type => :string
  should_have_column :body_part_id, :type => :integer
  should_have_column :cement_used, :type => :boolean
  should_have_column :spacer_used, :type => :boolean
  should_have_column :notes, :type => :text
  should_have_column :total_screws, :type => :integer

  should_belong_to :body_part
  should_belong_to :operation
end
