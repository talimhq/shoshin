class CreateAbilitySets < ActiveRecord::Migration[5.0]
  def change
    create_table :ability_sets do |t|
      t.integer :ability_items_count, default: 0, null: false
      t.string :name, null: false
      t.integer :position
      t.references :teaching_cycle, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
