# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_healer_session',
  :secret      => 'e6aa3702f6be8e98619ed84d924fb3c993bf3d101c60175c74ee0eada4528d4efd74c5f317c3b90cd1430543554ca37c14070c812e90f2cf5eb776f3282450c9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
