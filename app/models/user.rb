class User < ApplicationRecord

	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :perfil

  delegate :nome, to: :perfil, prefix: :perfil

  validates :perfil_id, :nome, :email, presence: true

end