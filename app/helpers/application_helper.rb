module ApplicationHelper
  # this will override default behavior for declarative_authorization. don't enable it unless you know what you're doing.
  # def permitted_to?(obj,action)
  #   true
  # end
  def request_ipad?
    request.user_agent.match(/iPad/)
  end

  def request_iphone?
    request.user_agent.match(/iPhone/)
  end

  def all_countries
    Carmen::Country.all.map{ |c| [c.name, c.code] }
  end
end
