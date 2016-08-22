class CreateTeachingCycles < ActiveRecord::Migration[5.0]
  def change
    create_table :teaching_cycles do |t|
      t.references :teaching, foreign_key: true, index: true, null: false
      t.references :cycle, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :teaching_cycles, [:teaching_id, :cycle_id], unique: true
  end
end
