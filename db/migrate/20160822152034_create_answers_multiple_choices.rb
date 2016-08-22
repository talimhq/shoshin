class CreateAnswersMultipleChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :answers_multiple_choices do |t|
      t.string :content, null: false
      t.boolean :correct, null: false, default: false
      t.references :question, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
