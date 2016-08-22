class CreateAnswersFileUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :answers_file_uploads do |t|
      t.string :file_format, null: false
      t.references :question, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
