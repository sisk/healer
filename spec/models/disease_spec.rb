require 'spec_helper'

describe Disease do
  it { should have_db_column(:base_name).of_type(:string) }
  it { should have_db_column(:code).of_type(:string) }
  it { should have_db_column(:display_order).of_type(:integer) }

  it{ should validate_presence_of(:base_name) }
  
  it { should have_many(:diagnoses) }
end
