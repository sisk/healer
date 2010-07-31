module ApplicationHelper
  # FIXME remove custom helper override when auth engine is fixed
  def permitted_to?(obj,action)
    true
  end
end
