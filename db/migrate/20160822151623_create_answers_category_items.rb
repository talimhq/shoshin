class CreateAnswersCategoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :answers_category_items do |t|
      t.string :content, null: false
      t.references :answers_category, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
