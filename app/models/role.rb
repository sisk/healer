class Role < ActiveRecord::Base
  # acts_as_authorization_role
  validates_presence_of :name, :message => "can't be blank"

  def self.available
    [:standard, :admin, :doctor, :nurse, :superuser, :anesthesiologist, :liaison]
  end

  has_and_belongs_to_many :users

  default_scope :order => 'roles.name'

  def to_s
    name
  end

end