class User < ApplicationRecord
	attr_accessor :remember_token, :reset_token

	before_save :downcase_email

	validates :email,			presence: true,
												length: { maximum: 240 },
												format: { with: URI::MailTo::EMAIL_REGEXP },
												uniqueness: { case_sensitive: false }
	validates :password,	presence: true,
												length: { minimum: 8 },
												allow_nil: true

	has_secure_password

	class << self
		# Returns the hash digest of the given string
		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end

		# Returns a random token
		def new_token
			SecureRandom.urlsafe_base64
		end
	end

	# Remembers a user in the database for persistent sessions
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Forgets a user
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Returns true if the given token matches the digest
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Creates the reset password attributes
	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)		
	end

	# Sends the password reset email
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Checks if password request is expired
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	private
		def downcase_email
			self.email = email.downcase
		end
end