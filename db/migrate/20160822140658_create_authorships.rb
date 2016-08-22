class CreateAuthorships < ActiveRecord::Migration[5.0]
  def change
    create_table :authorships do |t|
      t.references :teacher, foreign_key: true, index: true, null: false
      t.references :editable, polymorphic: true, index: true, null: false

      t.timestamps
    end

    add_index :authorships, [:editable_id, :teacher_id, :editable_type],
                            unique: true,
                            name: :index_authorships_on_teacher_and_editable
  end
end
