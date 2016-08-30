class CreateChapterLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :chapter_lessons do |t|
      t.references :chapter, foreign_key: true, index: true, null: false
      t.references :lesson, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :chapter_lessons, [:lesson_id, :chapter_id], unique: true
  end
end
