class AddAdvisorIconToStyles < ActiveRecord::Migration
  def change
    add_column :styles, :advisor_icon, :string
  end
end
