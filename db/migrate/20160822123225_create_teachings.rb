class CreateTeachings < ActiveRecord::Migration[5.0]
  def change
    create_table :teachings do |t|
      t.string :name, null: false
      t.string :short_name, null: false

      t.timestamps
    end
  end
end
