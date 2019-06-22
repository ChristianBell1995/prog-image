class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :images

  def make_associated_image(file)
    base_name = SecureRandom.urlsafe_base64
    images.create(filename: "#{id}/#{base_name}/#{base_name}", image: file)
  end
end
