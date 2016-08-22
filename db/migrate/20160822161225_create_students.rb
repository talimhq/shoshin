class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.references :classroom, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
