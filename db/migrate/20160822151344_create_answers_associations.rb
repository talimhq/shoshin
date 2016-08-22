class CreateAnswersAssociations < ActiveRecord::Migration[5.0]
  def change
    create_table :answers_associations do |t|
      t.string :left, null: false
      t.string :right, null: false
      t.references :question, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
