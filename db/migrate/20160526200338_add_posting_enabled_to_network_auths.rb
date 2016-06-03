class AddPostingEnabledToNetworkAuths < ActiveRecord::Migration
  def change
    add_column :facebook_auths, :posting_enabled, :boolean, default: true
    add_column :vkontakte_auths, :posting_enabled, :boolean, default: true
    add_column :twitter_auths, :posting_enabled, :boolean, default: true
  end
end
