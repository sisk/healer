class Disease < ActiveRecord::Base
  validates_presence_of :base_name
  # validates_numericality_of :display_order
end
