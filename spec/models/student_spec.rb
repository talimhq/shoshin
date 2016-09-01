require 'rails_helper'

RSpec.describe Student, type: :model do
  it_should_behave_like User do
    let(:user) { create(:student) }
  end

  describe 'db structure' do
    it { is_expected.to have_db_column(:classroom_id).of_type(:integer) }
    it { is_expected.to have_db_index(:classroom_id) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:classroom) }
    it { is_expected.to have_many(:student_groups) }
    it { is_expected.to have_many(:groups) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:classroom) }
  end

  describe 'factories' do
    it { expect(build(:student)).to be_valid }
  end

  describe 'callbacks' do
    context 'create student without password' do
      it 'should be valid' do
        student = Student.new(
          classroom: create(:classroom),
          account_attributes: {
            first_name: 'foo',
            last_name: 'bar',
            email: 'foo.bar@baz.com'
          }
        )
        expect(student).to be_valid
      end

      it 'sets 123456 as the default password' do
        student = Student.create(
          classroom: create(:classroom),
          account_attributes: {
            first_name: 'foo',
            last_name: 'bar',
            email: 'foo.bar@baz.com'
          }
        )
        expect(student.account.valid_password?('123456')).to be_truthy
      end
    end

    context 'create student without email' do
      it 'should be valid' do
        student = Student.new(
          classroom: create(:classroom),
          account_attributes: { first_name: 'foo',
                                last_name: 'bar',
                                password: '123456' }
        )
        expect(student).to be_valid
      end

      it 'should create an email based on student info' do
        student = Student.create(
          classroom: create(:classroom),
          account_attributes: { first_name: 'foo',
                                last_name: 'bar',
                                password: '123456' }
        )
        school = student.classroom.school
        expect(student.email).to eq("foo.bar@#{school.identifier.downcase}")
      end
    end
  end

  describe 'instance methods' do
    let(:student) { create(:student) }

    context 'can_access_lesson?' do
      let(:lesson) { create(:lesson) }

      it 'is true if lesson is in a chapter accessible by student' do
        teacher = create(:teacher)
        lesson.update(authors: [teacher])
        group = create(:group, teacher: teacher,
                               teaching: lesson.teaching,
                               level: lesson.levels.first)
        group.update(students: [student])
        chapter = create(:chapter, group: group)
        chapter.update(lessons: [lesson])
        expect(student.can_access_lesson?(lesson)).to be_truthy
      end

      it 'returns false if lesson does not have a chapter' do
        teacher = create(:teacher)
        lesson.update(authors: [teacher])
        group = create(:group, teacher: teacher,
                               teaching: lesson.teaching,
                               level: lesson.levels.first)
        group.update(students: [student])
        create(:chapter, group: group)
        expect(student.can_access_lesson?(lesson)).to be_falsy
      end

      it 'returns false if student does not have a group' do
        teacher = create(:teacher)
        lesson.update(authors: [teacher])
        group = create(:group, teacher: teacher,
                               teaching: lesson.teaching,
                               level: lesson.levels.first)
        chapter = create(:chapter, group: group)
        chapter.update(lessons: [lesson])
        expect(student.can_access_lesson?(lesson)).to be_falsy
      end

      it 'returns false if chapter and student belong in diff groups' do
        teacher = create(:teacher)
        lesson.update(authors: [teacher])
        group1 = create(:group, teacher: teacher,
                                teaching: lesson.teaching,
                                level: lesson.levels.first)
        group2 = create(:group, teacher: teacher,
                                teaching: lesson.teaching,
                                level: lesson.levels.first)
        group2.update(students: [student])
        chapter = create(:chapter, group: group1)
        chapter.update(lessons: [lesson])
        expect(student.can_access_lesson?(lesson)).to be_falsy
      end
    end
  end
end
