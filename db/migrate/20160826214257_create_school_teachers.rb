class CreateSchoolTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :school_teachers do |t|
      t.references :school, foreign_key: true, index: true, null: false
      t.references :teacher, foreign_key: true, index: false, null: false
      t.boolean :approved, null: false, default: false

      t.timestamps
    end

    remove_index :teachers, :school_id
    remove_column :teachers, :school_id, :integer
    add_index :school_teachers, :teacher_id, unique: true
  end
end
