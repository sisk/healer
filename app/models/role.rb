class Role < ActiveRecord::Base
  # acts_as_authorization_role
  validates_presence_of :name, :message => "can't be blank"

  def self.available
    [:admin, :doctor, :nurse, :superuser, :anesthesiologist]
  end

  has_and_belongs_to_many :users

  default_scope :order => 'roles.name'
  
  def to_s
    name
  end

end

# == Schema Information
#
# Table name: roles
#
#  id                :integer(4)      not null, primary key
#  name              :string(40)      not null
#  authorizable_type :string(40)
#  authorizable_id   :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

