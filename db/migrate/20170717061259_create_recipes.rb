class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.integer :status, null: false, default: Recipe.statuses[:editing]
      t.string :title, limit: 48
      t.string :description
      t.references :user, null: false
      t.string :video
      t.string :prep_time, limit: 32
      t.string :cook_time, limit: 32
      t.string :total_time, limit: 32
      t.string :recipe_yield, limit: 32
      t.datetime :published_at
      t.timestamps
    end
    add_index :recipes, [:status, :published_at]
  end
end
