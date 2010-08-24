require 'spec_helper'

describe Xray do
  should_have_column :date_time, :type => :datetime
  should_have_column :taken_at, :type => :string
  should_have_column :photo_file_name, :type => :string
  should_have_column :photo_content_type, :type => :string
  should_have_column :photo_file_size, :type => :integer

  # should_validate_presence_of :photo
  should_belong_to :diagnosis

end
