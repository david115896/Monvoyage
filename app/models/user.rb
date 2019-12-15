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
			self.is_admin = false
	end

	def tempo_session
		session[:tempo_organiser] = cookies[:tempo_organiser]
	end

	def organiser_save
		if cookies[:tempo_organiser] =! nil
			hash = JSON.parse session[:tempo_organiser]
			cookies[:organiser_id] = Organiser.create(city_id: hash[:city_id], user: User.all.sample)
		end
	end

	def restore_organiser
		o =	Organiser.last
		o.user = current_user
	end

end
