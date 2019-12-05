class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

	after_create :set_is_admin
  after_create :welcome_send

	has_many :organizers
	has_many :carts
	has_many :activities, through: :carts


  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
				 
	def set_is_admin
		self.is_admin = false
		self.save
	end

end
