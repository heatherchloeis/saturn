class User < ApplicationRecord
	before_save :downcase_email

	validates :email,			presence: true,
												length: { maximum: 240 },
												format: { with: URI::MailTo::EMAIL_REGEXP },
												uniqueness: { case_sensitive: false }
	validates :password,	presence: true,
												length: { minimum: 8 },
												allow_nil: true

	has_secure_password

	private
		def downcase_email
			self.email = email.downcase
		end
end