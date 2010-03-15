# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_king_session',
  :secret      => 'b6c2c35b4f85cb07325ea811d6333c8d97096028a9ff4ba6baa1251d0fa573cd0bda34dd7e8584cceb065e2464712c452de92523edb9a118bfb76f5771def9da'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
