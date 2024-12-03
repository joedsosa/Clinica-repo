class CreateMedicines < ActiveRecord::Migration[7.1]
  def change
    create_table :medicines do |t|
      t.string :name
      t.text :description
      t.string :dosage
      t.string :dosage_form
      t.text :instructions

      t.timestamps
    end
  end
end
