class Patient < ActiveRecord::Base
  validates_presence_of :name_first, :message => "can't be blank"
  validates_presence_of :name_last, :message => "can't be blank"
  validates_inclusion_of :male, :in => [true, false]
  
  has_many :patient_interactions
  
  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end
  
end
