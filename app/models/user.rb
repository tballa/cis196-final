class User < ApplicationRecord
  include BCrypt
  has_many :messages, dependent: :destroy
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
  validates :name, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates_email_format_of :email 
  validate :capitalized

  def capitalized
    errors.add(:name, 'is not capitalized.') if name && name.starts_with?(name.downcase)
  end

  def password
    @password ||= Password.new(password_hash) if password_hash
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def takedown_target(target)
    target.update(active: false)
  end

  def reinstate_player(target)
    target.update(active: true)
  end

  def view_target
    User.find_by(name: self.target)
  end

  def messages_for_admin
    Message.joins(:user).where(users: { admin: false })
  end

  def messages_for_players
    Message.joins(:user).where(users: { admin: true })
  end

  def get_attacker
    User.find_by(target: self.name)
  end

  def self.eliminate_inactive_players
    User.offset(1).each do |user|
      user.destroy unless user.active
    end
  end

  def self.pair_users
    if User.all.size > 2
      target = User.second
        User.offset(2).each do |user|
        user.update(target: target.name)
        target = user
      end
      User.second.update(target: target.name)
    end
  end
end
