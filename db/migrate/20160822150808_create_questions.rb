class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.references :exercise, foreign_key: true, index: true, null: false
      t.integer :position
      t.string :type, null: false
      t.text :content, null: false
      t.text :help

      t.timestamps
    end
  end
end
