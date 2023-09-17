class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # A user can be either an organizer or a participant       
  enum role: {organizer: 0, participant: 1}

  has_many :events, -> { where(role: 'organizer') }, class_name: 'Event', foreign_key: 'user'
  has_many :participations
  has_many :registered_events, through: :participations, source: :event

end
