class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :user
      t.string :file
      t.string :attachment
      t.timestamps
    end
  end
end
