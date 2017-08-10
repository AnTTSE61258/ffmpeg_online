class CreateTestings < ActiveRecord::Migration[5.1]
  def change
    create_table :testings, &:timestamps
  end
end
