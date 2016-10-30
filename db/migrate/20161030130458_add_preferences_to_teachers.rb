class AddPreferencesToTeachers < ActiveRecord::Migration[5.0]
  def change
    add_column :teachers, :preferences, :jsonb, default: {level_id: '', teaching_id: ''}, null: false
    add_index :teachers, :preferences, using: :gin
  end
end
