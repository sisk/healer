require 'spec_helper'

describe PatientInteraction do
  it_has_the_attribute :notes, :type => :text
  it_has_the_attribute :date_time, :type => :datetime
  it{should belong_to(:patient)}
  it{should belong_to(:provider)}
end
