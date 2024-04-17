class AddCroppingFieldsToPhoto < ActiveRecord::Migration[7.1]
  def change
    add_column :photos, :x, :integer
    add_column :photos, :y, :integer
    add_column :photos, :w, :integer
    add_column :photos, :h, :integer
  end
end
