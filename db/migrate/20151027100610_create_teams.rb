class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string  :name
      t.integer :points
      t.integer :won
      t.integer :lost
      t.integer :draw
      t.integer :goal_diff

      t.timestamps null: false
    end
  end
end
