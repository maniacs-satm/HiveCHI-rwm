class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :name
      t.string  :address
      t.string  :start_date_and_time
      t.string  :duration
      t.string  :description_url
      t.belongs_to  :organization


      t.timestamps null: false
    end
  end
end
