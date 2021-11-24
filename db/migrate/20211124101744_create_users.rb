class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password
      t.integer :attempts, :default => 0
      t.boolean :locked, :default => false

      t.timestamps
    end
  end
end
