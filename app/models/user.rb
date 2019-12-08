class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

	after_create :set_is_admin
 	after_create :welcome_send

	has_many :organisers

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
				 
	def set_is_admin
		if check_admin(self)
			self.is_admin = true
		else
			self.is_admin = false
		end
		self.save
	end

	def check_admin(user)
		if (user.email == "yoyo@yopmail.com" || user.email == "gluglu@yopmail.com" || user.email == "hibou@yopmail.com")
			return true
		else 
			return false
		end
	end

	def organiser_save
		if cookies[:tempo_organiser] =! nil
			hash = JSON.parse cookies[:tempo_organiser]
			cookies[:organiser_id] = Organiser.create(city_id: hash[:city_id], user: current_user)
		end
	end
end
