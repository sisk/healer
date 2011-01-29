class XraysController < ApplicationController
  inherit_resources
  belongs_to :operation, :diagnosis, :polymorphic => true
end
