class User < ApplicationRecord
  after_create :generateApkiKey
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]
	has_many :microposts
	
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def generateApkiKey
    loop do
      apitoken = self.apitoken = SecureRandom.urlsafe_base64(20, false)
      break apitoken unless self.class.exists?(apitoken: apitoken)
    end
    self.save
    print apitoken
  end

end
