class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.integer :position
      t.integer :expectations_count, default: 0, null: false
      t.references :teaching_cycle, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
