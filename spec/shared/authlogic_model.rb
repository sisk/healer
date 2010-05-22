describe 'authlogic_model', :shared => true do

  it_has_the_attribute :login, :type => :string
  # it_has_the_attribute :email, :type => :string
  it_has_the_attribute :crypted_password, :type => :string
  it_has_the_attribute :password_salt, :type => :string
  it_has_the_attribute :persistence_token, :type => :string
  it_has_the_attribute :perishable_token, :type => :string
  it_has_the_attribute :current_login_ip, :type => :string
  it_has_the_attribute :last_login_ip, :type => :string

  it_has_the_attribute :login_count, :type => :integer
  it_has_the_attribute :failed_login_count, :type => :integer

  it_has_the_attribute :last_request_at, :type => :datetime
  it_has_the_attribute :current_login_at, :type => :datetime
  it_has_the_attribute :last_login_at, :type => :datetime

end