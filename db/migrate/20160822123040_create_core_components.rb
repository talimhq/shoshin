class CreateCoreComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :core_components do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
