class CreateChapterExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :chapter_exercises do |t|
      t.references :chapter, foreign_key: true, index: true, null: false
      t.references :exercise, foreign_key: true, index: true, null: false
      t.integer :position
      t.integer :max_tries, default: 0, null: false
      t.datetime :due_date

      t.timestamps
    end

    add_index :chapter_exercises, [:exercise_id, :chapter_id], unique: true
  end
end
