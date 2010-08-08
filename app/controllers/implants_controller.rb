class ImplantsController < InheritedResources::Base
  belongs_to :operation, :singleton => true
  
end
