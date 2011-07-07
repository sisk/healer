# encoding: UTF-8
class User < ActiveRecord::Base
  def self.languages
    {"en" => "English", "es" => "Español"}
  end

  # acts_as_authorization_subject

  # Include default devise modules. Others available are:
  # :token_authenticatable, :registerable, :lockable and :timeoutable, :confirmable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :name_last, :name_first, :language, :authorized

  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
                    # :email => true
  
  validates_presence_of :name_first, :message => "can't be blank"
  validates_presence_of :name_last, :message => "can't be blank"

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :trips

  scope :can_login, where("users.authorized = ?", true)
  scope :cant_login, where("users.authorized = ?", false)
  
  scope :search, lambda { |term|
    query = term.strip.gsub(',', '')
    first_last = query.split(" ")
    if query.present?
      if first_last.size == 2
        { :conditions => ["users.name_first like ? and users.name_last like ?","%#{first_last[0]}%","%#{first_last[1]}%" ] }
      else
        query = query.gsub(/[^\w@\.]/x,'')
        { :conditions => ["users.name_last like ? or users.name_first like ? or users.email like ?","%#{query}%","%#{query}%","%#{query}%" ] }
      end
    end
  }

  default_scope :order => 'users.name_last, users.name_first'

  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end

  def role_symbols
    (roles || []).map {|r| r.name.dehumanize.to_sym}
  end
  
  Role.available.map{ |rr| rr.to_s }.each do |r|
    attr_accessible "has_role_#{r}".to_sym
    scope r.to_sym, :include => :roles, :conditions => [ "roles.name = ?", r ]
    define_method("has_role_#{r}") do
      has_role?(r)
    end
    define_method("has_role_#{r}=") do |args|
      args == "1" ? self.grant_role!(r) : self.revoke_role!(r)
    end
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