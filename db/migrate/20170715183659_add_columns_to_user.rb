class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nome, :string
    add_column :users, :perfil_id, :integer
  end
end
