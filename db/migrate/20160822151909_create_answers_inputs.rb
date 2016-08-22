class CreateAnswersInputs < ActiveRecord::Migration[5.0]
  def change
    create_table :answers_inputs do |t|
      t.string :content, null: false
      t.references :question, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
