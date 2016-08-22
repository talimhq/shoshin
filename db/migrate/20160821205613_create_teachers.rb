class CreateTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :teachers do |t|
      t.references :school, foreign_key: true, index: true
      t.boolean :approved, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.integer :old_id

      t.timestamps
    end

    add_index :teachers, :old_id
  end
end
