class CreateGroupNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :group_notifications do |t|
      t.references :group, foreign_key: true, index: true, null: false
      t.references :user, polymorphic: true, index: true, null: false
      t.text :body, null: false
      t.string :kind, null: false

      t.timestamps
    end
  end
end
