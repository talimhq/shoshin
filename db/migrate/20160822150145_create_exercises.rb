class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :name, null: false
      t.text :statement
      t.integer :time, default: 10, null: false
      t.integer :popularity, default: 0, null: false
      t.integer :authorships_count, default: 0, null: false
      t.boolean :exam, default: false, null: false
      t.integer :original_id
      t.integer :difficulty, default: 2, null: false
      t.boolean :shared, default: true, null: false
      t.references :teaching, foreign_key: true, index: true, null: false
      t.integer :questions_count, default: 0, null: false
      t.integer :old_id
      t.integer :level_ids, default: [], array: true

      t.timestamps
    end

    add_index :exercises, :old_id
  end
end
