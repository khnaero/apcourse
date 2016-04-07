class ChangeDescription < ActiveRecord::Migration
  def change
  	rename_column :locations, :description, :name
  end
end
