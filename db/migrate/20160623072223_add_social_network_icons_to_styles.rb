class AddSocialNetworkIconsToStyles < ActiveRecord::Migration
  def change
    Style::ICONS_ATTRS.each do |name|
      add_column :styles, name, :string
    end
  end
end
