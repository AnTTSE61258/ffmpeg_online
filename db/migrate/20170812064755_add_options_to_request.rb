class AddOptionsToRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :format, :string
  end
end
