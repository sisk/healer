class ImplantsController < ApplicationController
  inherit_resources
  
  belongs_to :operation, :singleton => true
  
  private
  
  # def build_resource 
  #    super
  #    @implant ||= @operation.build_implant
  #    puts @implant.inspect
  #    @implant
  # end
  
end
