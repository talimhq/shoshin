namespace :db do
  desc 'Import teachers'
  task import_teachers: [:environment] do
    teachers_array = YAML.load_file('db/seeds/teachers.yml')
    teachers_array.each do |teacher_hash|
      teacher_hash.delete(:role)
      old_id = teacher_hash.delete(:old_id)
      admin = teacher_hash.delete(:admin)
      teacher = Teacher.new(old_id: old_id,
                            admin: admin,
                            account_attributes: teacher_hash)
      teacher.save(validate: false)
    end
  end

  desc 'Import lessons'
  task import_lessons: [:environment] do
    lessons_array = YAML.load_file('db/seeds/chapters.yml')
    lessons_array.each do |lesson_hash|
      teacher_id = lesson_hash.delete(:teacher_id)
      level_name = lesson_hash.delete(:level_name)
      field_name = lesson_hash.delete(:field_name)
      steps_array = lesson_hash.delete(:steps)
      teaching = Teaching.find_by(name: field_name)
      level = Level.find_by(name: level_name)
      lesson = Lesson.new(lesson_hash.merge(teaching_id: teaching.id, level_ids: [level.id]))
      lesson.save
      teacher = Teacher.find_by(old_id: teacher_id)
      lesson.update(authors: [teacher])
      steps_array.each do |step_hash|
        step = Step.new(step_hash)
        step.lesson = lesson
        step.save
      end
    end
  end

  desc 'Import exercises'
  task import_exercises: [:environment] do
    exercises_array = YAML.load_file('db/seeds/exercises.yml')
    exercises_array.each do |exercise_hash|
      questions_array = exercise_hash.delete(:questions)
      teacher = Teacher.find_by(old_id: exercise_hash.delete(:teacher_id))
      teaching = Teaching.find_by(name: exercise_hash.delete(:teaching_name))
      level = Level.find_by(name: exercise_hash.delete(:level_name))
      exercise = Exercise.create!(exercise_hash.merge(level_ids: [level.id], teaching_id: teaching.id))
      exercise.update(authors: [teacher])
      questions_array.each do |question_hash|
        answers_array = question_hash.delete(:answers)
        question = Question.create!(question_hash.merge(exercise_id: exercise.id))
        question.update(answers_attributes: answers_array)
      end
    end
  end

  desc 'Import schools'
  task import_schools: [:environment] do
    schools_array = YAML.load_file('db/seeds/schools.yml')
    schools_array.each do |school_hash|
      teacher_ids = school_hash.delete(:teacher_ids)
      school = School.create!(school_hash)
      Teacher.where(old_id: teacher_ids)
             .update_all(school_id: school.id, approved: true)
    end
  end
end
