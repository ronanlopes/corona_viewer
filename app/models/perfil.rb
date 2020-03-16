class Perfil < ApplicationRecord

	validates :nome, presence: true

	def to_s
		self.nome
	end


end
