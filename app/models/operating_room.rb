class OperatingRoom < ActiveRecord::Base
  belongs_to :facility
  validates_presence_of :facility
  has_many :operations
end
