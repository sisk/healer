require 'spec_helper'

describe BodyPart do
  it { should have_db_column(:name).of_type(:string) }
  it { should validate_presence_of(:name) }

  it { should have_many(:diagnoses) }
end

# == Schema Information
#
# Table name: body_parts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

