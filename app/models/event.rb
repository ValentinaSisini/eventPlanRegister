class Event < ApplicationRecord
  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
  has_many :notifications

end
