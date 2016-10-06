class AddEvaluationToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :ability_evaluations, :jsonb, default: {}
    add_column :assignments, :expectation_evaluations, :jsonb, default: {}
    add_index :assignments, :ability_evaluations, using: :gin
    add_index :assignments, :expectation_evaluations, using: :gin
  end
end
