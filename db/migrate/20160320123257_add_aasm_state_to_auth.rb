class AddAasmStateToAuth < ActiveRecord::Migration
  def change
    add_column :auths, :aasm_state, :string
  end
end
