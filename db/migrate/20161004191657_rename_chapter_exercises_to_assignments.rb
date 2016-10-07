class RenameChapterExercisesToAssignments < ActiveRecord::Migration[5.0]
  def change
    rename_table :chapter_exercises, :assignments
  end
end
