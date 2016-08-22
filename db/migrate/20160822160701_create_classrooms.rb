class CreateClassrooms < ActiveRecord::Migration[5.0]
  def change
    create_table :classrooms do |t|
      t.string :name, null: false
      t.references :level, foreign_key: true, index: true, null: false
      t.references :school, foreign_key: true, index: true, null: false
      t.integer :students_count, default: 0, null: false

      t.timestamps
    end

    add_index :classrooms, [:school_id, :name], unique: true
  end
end
