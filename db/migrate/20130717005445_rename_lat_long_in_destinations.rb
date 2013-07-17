class RenameLatLongInDestinations < ActiveRecord::Migration
  def change
    rename_column :destinations, :lat, :latitude
    rename_column :destinations, :long, :longitude
    add_column :destinations, :address, :string
  end
end
