class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :description
      t.integer :amount_cents
      t.string :kind
      t.string :category
      t.date :occurred_on

      t.timestamps
    end
  end
end
