class ApplicationController < ActionController::Base
	def Home
		@title = "Home"
	end

	def About
		@title = "About"
	end

	def Live_Stream
		@title = "Watch Live"
	end

	def Contact
		@title = "Contact"
	end

	private
		# Confirms logged-in user
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Please log in (ﾉಠ_ಠ)ﾉ 彡 ┻━┻"
				redirect_to login_url
			end
		end
end
