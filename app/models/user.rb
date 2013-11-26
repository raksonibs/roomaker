class User < ActiveRecord::Base
	has_secure_password
  has_and_belongs_to_many :pendingtasks
  has_many :acceptedtasks
  has_many :currenttasks
  has_many :completedtasks
  has_and_belongs_to_many :groups
  has_many :nods
  has_many :nos
  has_many :incompletetasks
  has_many :invites
  has_many :asks
  
	def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.password="cat"
      user.password_confirmation="cat"
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def self.addpending(id, pendingtask)
    User.find_by_id(id).pendingtasks.create!(pendingtask)
  end


end
