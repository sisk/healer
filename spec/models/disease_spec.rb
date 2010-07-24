require 'spec_helper'

describe Disease do
  it{should validate_presence_of(:base_name)}
  # it{should validate_numericality_of(:display_order)}
end
