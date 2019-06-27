class AddStatusToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :status, :int, default: 0
  end
end
