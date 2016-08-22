class CreateExpectations < ActiveRecord::Migration[5.0]
  def change
    create_table :expectations do |t|
      t.string :name, null: false
      t.references :theme, foreign_key: true, index: true, null: false
      t.integer :knowledge_items_count, default: 0, null: false

      t.timestamps
    end
  end
end
