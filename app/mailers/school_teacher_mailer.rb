class SchoolTeacherMailer < ApplicationMailer
  def new_teacher(school_teacher)
    @new_teacher = school_teacher.teacher
    teachers = school_teacher.school.teachers.map(&:email)
    if teachers.any?
      mail to: teachers, subject: 'Nouveau professeur'
    else
      admins = Teacher.where(admin: true).map(&:email)
      mail to: admins, subject: 'Nouveau professeur',
           template_name: 'new_teacher_admin'
    end
  end
end
