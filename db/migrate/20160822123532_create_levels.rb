class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.references :cycle, foreign_key: true, index: true, null: false
      t.integer :position
      t.string :name, null: false
      t.string :short_name, null: false
      t.string :level_type, null: false

      t.timestamps
    end
  end
end
