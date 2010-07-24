class Disease < ActiveRecord::Base
  validates_presence_of :base_name
  has_many :diagnoses
end
