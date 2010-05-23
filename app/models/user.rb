class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorization_subject  :association_name => :roles
  
  validates_presence_of :login, :on => :save, :message => "can't be blank"
  validates_presence_of :name_first, :on => :save, :message => "can't be blank"
  validates_presence_of :name_last, :on => :save, :message => "can't be blank"

  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end

end

# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  name_first          :string(255)     not null
#  name_last           :string(255)     not null
#

