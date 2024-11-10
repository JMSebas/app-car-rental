class CreatePaymentTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_types do |t|
      t.string :type

      t.timestamps
    end
  end
end
