json.extract! user, :id, :name, :email, :password_digest, :verified, :verification_token, :remember_me_token, :password_reset_token, :password_reset_send_at, :created_at, :updated_at
json.url user_url(user, format: :json)
