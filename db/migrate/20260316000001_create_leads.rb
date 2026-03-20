class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :company
      t.text :message, null: false
      t.string :honeypot
      t.string :ip_address

      t.timestamps
    end
  end
end
