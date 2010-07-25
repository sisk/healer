class Implant < ActiveRecord::Base
  belongs_to :operation
  belongs_to :body_part
end