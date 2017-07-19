class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :code
      t.string :name
      t.text :description
    end
  end
end
