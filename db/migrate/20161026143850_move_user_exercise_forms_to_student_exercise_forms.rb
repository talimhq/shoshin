class MoveUserExerciseFormsToStudentExerciseForms < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      INSERT INTO student_exercise_forms (assignment_id, student_id, answers, results, created_at, updated_at)
        SELECT assignments.id, user_exercise_forms.user_id, user_exercise_forms.answers, user_exercise_forms.results, user_exercise_forms.created_at, user_exercise_forms.updated_at
          FROM assignments, user_exercise_forms
          WHERE user_exercise_forms.user_type = 'Student'
            AND user_exercise_forms.exercise_id = assignments.exercise_id
      ;
      DELETE FROM user_exercise_forms WHERE user_type = 'Student';
    SQL
  end

  def down
    execute <<-SQL
      INSERT INTO user_exercise_forms (exercise_id, user_id, user_type, answers, results, created_at, updated_at)
        SELECT exercises.id, student_exercise_forms.student_id, 'Student', student_exercise_forms.answers, student_exercise_forms.results, student_exercise_forms.created_at, student_exercise_forms.updated_at
          FROM student_exercise_forms, assignments, exercises
          WHERE student_exercise_forms.assignment_id = assignments.id
            AND assignments.exercise_id = exercises.id
      ;
      DELETE FROM student_exercise_forms;
    SQL
  end
end
