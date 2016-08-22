class CreateAbilityItems < ActiveRecord::Migration[5.0]
  def change
    create_table :ability_items do |t|
      t.string :name, null: false
      t.integer :position
      t.references :ability_set, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
