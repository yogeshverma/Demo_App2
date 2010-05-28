# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_artquest_session',
  :secret      => '6b556e1932ccc87e9b7803c70be628571e915f26a19e1a9ecb8856ab874632938d695172b5d3401dc30525e42c26d27dbed3f6de0858c8318ef184fed07ed24d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
