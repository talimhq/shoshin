class CreateTeacherExerciseForms < ActiveRecord::Migration[5.0]
  def change
    create_table :user_exercise_forms do |t|
      t.references :user, polymorphic: true, index: true, null: false
      t.references :exercise, foreign_key: true, index: true, null: false
      t.jsonb :answers, default: {}, null: false
      t.jsonb :results, default: {}, null: false

      t.timestamps
    end

    add_index :user_exercise_forms, :answers, using: :gin
    add_index :user_exercise_forms, :results, using: :gin
  end
end
