class CreateDestinationsUsersBridge < ActiveRecord::Migration
  def change
    create_table :destinations_users do |t|
      t.integer :destination_id
      t.integer :user_id
    end
  end
end
