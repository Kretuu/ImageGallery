class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :photo_galleries, dependent: :destroy

  validates :first_name, :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end
end
