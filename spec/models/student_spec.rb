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
    it { is_expected.to have_many(:user_exercise_forms) }
    it { is_expected.to have_many(:group_notifications) }
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
        expect(student.email).to eq("bar.foo@#{school.identifier.downcase}")
      end
    end
  end

  describe 'instance methods' do
    let(:student) { create(:student) }

    it 'admin? is false' do
      expect(student.admin?).to be_falsy
    end

    it 'approved? is true' do
      expect(student.approved?).to be_truthy
    end
  end
end
