class CreateThemeLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :theme_levels do |t|
      t.references :theme, foreign_key: true, index: true, null: false
      t.references :level, foreign_key: true, index: true, null: false
      t.string :kind, null: false

      t.timestamps
    end
  end
end
