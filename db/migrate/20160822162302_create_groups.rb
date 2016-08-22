class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.references :teaching, foreign_key: true, index: true, null: false
      t.references :level, foreign_key: true, index: true, null: false
      t.references :teacher, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
