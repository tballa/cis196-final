class Message < ApplicationRecord
  belongs_to :user
  validates :text, presence: true
  validates :text, length: { minimum: 5 }
end