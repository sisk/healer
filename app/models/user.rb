class User < ActiveRecord::Base
  validates_presence_of :login, :on => :create, :message => "can't be blank"
  validates_presence_of :name_first, :on => :create, :message => "can't be blank"
  validates_presence_of :name_last, :on => :create, :message => "can't be blank"
  
  # def to_s(opts = {})
  #   str = name(opts)
  #   str << " [#{network_id}]" if opts[:full]
  #   str
  # end
  
  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end
end
