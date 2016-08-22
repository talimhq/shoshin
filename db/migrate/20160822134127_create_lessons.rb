class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :name, null: false
      t.integer :old_id
      t.integer :original_id
      t.integer :popularity, default: 0, null: false
      t.boolean :shared, default: true, null: false
      t.integer :steps_count, default: 0, null: false
      t.integer :authorships_count, default: 0, null: false
      t.references :teaching, foreign_key: true, index: true, null: false
      t.integer :level_ids, default: [], array: true

      t.timestamps
    end
    add_index :lessons, :old_id
    add_index :lessons, :original_id
  end
end
