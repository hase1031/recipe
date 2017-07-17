class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.references :recipe
      t.string :name
      t.string :volume
      t.timestamps
    end
  end
end
