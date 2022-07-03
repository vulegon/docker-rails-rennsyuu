class RenameEmialColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :emial, :email
  end
end
