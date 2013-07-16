class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.float :lat
      t.float :long

      t.timestamps
    end
  end
end
