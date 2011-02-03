class XraysController < ApplicationController
  inherit_resources
  belongs_to :operation, :diagnosis, :polymorphic => true, :optional => true
  
  def destroy
    destroy! { :back }
  end
  
end
