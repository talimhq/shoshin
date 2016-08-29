class CreateStudentGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :student_groups do |t|
      t.references :student, foreign_key: true, index: true, null: false
      t.references :group, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :student_groups, [:group_id, :student_id], unique: true
  end
end
