class AddVideoSizeToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :o_h, :integer
    add_column :requests, :o_w, :integer
    add_column :requests, :n_h, :integer
    add_column :requests, :n_w, :integer
  end
end
