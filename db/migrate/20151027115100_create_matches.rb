class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :result
      t.integer :week
      t.timestamps null: false
    end
  end
end
