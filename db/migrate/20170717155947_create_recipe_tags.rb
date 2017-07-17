class CreateRecipeTags < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_tags do |t|
      t.references :recipe
      t.references :tag
      t.timestamps
    end
    add_index :recipe_tags, [:recipe_id, :tag_id]
  end
end
