class CreateKnowledgeItems < ActiveRecord::Migration[5.0]
  def change
    create_table :knowledge_items do |t|
      t.string :name, null: false
      t.references :expectation, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
