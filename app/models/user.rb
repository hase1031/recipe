class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true, length: {maximum: 24}
  validates_email_format_of :email, presence: true, uniqueness: true
  validates :email, confirmation: true, on: :update
  validates :password, confirmation: true, if: -> { new_record? && password_required? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? && password_required? || changes["password"] }

  has_many :recipes

end
