class CreateHorarioDisponivelConsultoras < ActiveRecord::Migration[5.0]
  def change
    create_table :horario_disponivel_consultoras do |t|
      t.integer :dia
      t.string :hora_inicio
      t.string :hora_fim
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
