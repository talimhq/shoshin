class Question < ApplicationRecord
  belongs_to :exercise, inverse_of: :questions, counter_cache: true
  acts_as_list scope: :exercise

  validates :content, :exercise, :type, presence: true
  validates :type, inclusion: { in: %w(Questions::Input Questions::SingleChoice Questions::MultipleChoice Questions::Association Questions::Classify Questions::Redaction Questions::FileUpload) }

  delegate :authors, to: :exercise, prefix: false
  delegate :name, to: :exercise, prefix: true
  delegate :statement, to: :exercise, prefix: true

  def self.types
    %w(Questions::Input Questions::SingleChoice Questions::MultipleChoice Questions::Association Questions::Classify Questions::Redaction Questions::FileUpload)
  end

  def self.type_options
    [
      ['Saisir une/la bonne réponse', 'Questions::Input'],
      ['Choisir la bonne réponse', 'Questions::SingleChoice'],
      ['Choisir les bonnes réponses', 'Questions::MultipleChoice'],
      ['Associer les éléments correspondants', 'Questions::Association'],
      ['Classer les réponses par catégorie', 'Questions::Classify'],
      ['Rédiger une réponse *', 'Questions::Redaction'],
      ['Déposer un fichier *', 'Questions::FileUpload']
    ]
  end

  def print_type
    type.split(':').last.underscore
  end

  def print_title
    "Question #{position}"
  end

  def async?
    print_type.in? %w(redaction file_upload)
  end

  def build_copy(new_exercise)
    new_exercise.questions.new(content: content, position: position, type: type)
  end
end
