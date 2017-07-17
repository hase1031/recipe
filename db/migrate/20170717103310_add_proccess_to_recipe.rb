class AddProccessToRecipe < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :markdown, :text, limit: 65535, after: :video
    add_column :recipes, :html, :text, limit: 65535, after: :markdown
  end
end
