class CreateAnswersCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :answers_categories do |t|
      t.string :name, null: false
      t.references :question, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
