class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :omniauthable, omniauth_providers: %i[doorauth]

  class << self
    def from_omniauth(auth)
      User.find_or_initialize_by(id: auth['extra']['raw_info']['id'])
    end
  end
end
