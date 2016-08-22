class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :identifier, null: false
      t.string :country, null: false
      t.string :state, null: false
      t.string :city, null: false
      t.string :website
      t.string :email
      t.integer :teachers_count, default: 0, null: false

      t.timestamps
    end

    add_index :schools, :country
    add_index :schools, [:state, :country]
    add_index :schools, [:city, :state, :country]
    add_index :schools, :identifier, unique: true
  end
end
