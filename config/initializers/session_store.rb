# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gokii_session',
  :secret      => '1aa8c691fd26fd2061d62ddd66ea324bc8499865dc363f9abc40caf10f394bd2a0f7add202778bf153389da97fd4b21cf88411e42d7d1d2390add74de0120cf4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
