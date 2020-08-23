class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :status, null: false
      t.integer :client_id

      t.timestamps
    end

    add_foreign_key :clients, :projects
  end
end
