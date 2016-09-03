class CreateEditableLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :editable_levels do |t|
      t.references :editable, polymorphic: true, index: true, null: false
      t.references :level, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :editable_levels, [:editable_id, :editable_type, :level_id],
              name: :index_editable_levels_on_editable_and_level, unique: true

    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO editable_levels (level_id, editable_id, editable_type, created_at, updated_at)
            SELECT unnest(level_ids), id, 'Exercise', LOCALTIMESTAMP, LOCALTIMESTAMP FROM exercises;
          INSERT INTO editable_levels (level_id, editable_id, editable_type, created_at, updated_at)
            SELECT unnest(level_ids), id, 'Lesson', LOCALTIMESTAMP, LOCALTIMESTAMP FROM lessons;
        SQL
      end

      dir.down do
        execute <<-SQL
          UPDATE exercises
            SET level_ids = array_append(level_ids, editable_levels.level_id)
            FROM editable_levels
            WHERE  exercises.id = editable_levels.editable_id
            AND editable_levels.editable_type = 'Exercise';
          UPDATE lessons
            SET level_ids = array_append(level_ids, editable_levels.level_id)
            FROM editable_levels
            WHERE  lessons.id = editable_levels.editable_id
            AND editable_levels.editable_type = 'Lesson';
        SQL
      end
    end

    remove_column :exercises, :level_ids, :integer, array: true, default: []
    remove_column :lessons, :level_ids, :integer, array: true, default: []
  end
end
