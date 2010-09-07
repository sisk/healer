class User < ActiveRecord::Base
  # acts_as_authorization_subject

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :name_last, :name_first

  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
                    # :email => true
  
  validates_presence_of :name_first, :message => "can't be blank"
  validates_presence_of :name_last, :message => "can't be blank"

  has_and_belongs_to_many :roles

  scope :doctor, :include => :roles, :conditions => [ "roles.name = ?", "doctor" ]
  scope :nurse, :include => :roles, :conditions => [ "roles.name = ?", "nurse" ]
  scope :admin, :include => :roles, :conditions => [ "roles.name = ?", "admin" ]
  scope :superuser, :include => :roles, :conditions => [ "roles.name = ?", "superuser" ]

  default_scope :order => 'users.name_last, users.name_first'

  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end

  # def self.roles(*syms)
  #   # uses methods for Acl9 to grant roles via form
  #   return @roles if syms.empty?
  #   syms = syms.collect(&:to_s).collect(&:downcase).collect(&:underscore).collect(&:to_sym)
  #   syms.each { |sym|
  #     attr_accessor "has_role_#{sym}".to_sym
  #     self.send(:define_method, "has_role_#{sym}") do
  #       has_role? sym.to_s
  #     end
  #     self.send(:define_method, "has_role_#{sym}=") do |args|
  #       args == "1" ? has_role!(sym.to_s) : has_no_role!(sym.to_s) 
  #     end
  #   }
  #   @roles = syms
  # end
  # roles :admin, :doctor, :nurse

  def role_symbols
    (roles || []).map {|r| r.name.dehumanize.to_sym}
  end
  
  # TODO refactor below
  attr_accessible :has_role_admin, :has_role_superuser, :has_role_doctor, :has_role_nurse

  def has_role_admin
    has_role?("admin")
  end
  def has_role_doctor
    has_role?("doctor")
  end
  def has_role_nurse
    has_role?("nurse")
  end
  def has_role_superuser
    has_role?("superuser")
  end
  def has_role_admin=(args)
    args == "1" ? self.grant_role!("admin") : self.revoke_role!("admin")
  end
  def has_role_doctor=(args)
    args == "1" ? self.grant_role!("doctor") : self.revoke_role!("doctor")
  end
  def has_role_nurse=(args)
    args == "1" ? self.grant_role!("nurse") : self.revoke_role!("nurse")
  end
  def has_role_superuser=(args)
    args == "1" ? self.grant_role!("superuser") : self.revoke_role!("superuser")
  end

  def grant_role!(role_name)
    self.roles << Role.find_or_create_by_name(role_name.to_s) unless has_role?(role_name)
  end
  def revoke_role!(role_name)
    self.roles.delete(Role.find_by_name(role_name.to_s)) unless !has_role?(role_name)
  end

  private
  
  def has_role?(role_name)
    role_symbols.include?(role_name.dehumanize.to_sym)
  end

end