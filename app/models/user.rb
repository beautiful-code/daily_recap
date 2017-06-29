class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_many :daily_logs
  validates :name, presence: true
  validates :email, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email=auth.info.email
      user.picture=auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = auth.credentials.expires_at
      user.save!
    end
  end
end

