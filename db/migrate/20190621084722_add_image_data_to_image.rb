class AddImageDataToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :image_data, :text
  end
end
