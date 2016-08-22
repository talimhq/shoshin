class CreateSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :steps do |t|
      t.references :lesson, foreign_key: true, index: true, null: false
      t.string :title
      t.text :content, null: false
      t.integer :position

      t.timestamps
    end
  end
end
