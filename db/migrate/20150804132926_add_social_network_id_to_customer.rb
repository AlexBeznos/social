class AddSocialNetworkIdToCustomer < ActiveRecord::Migration
  def change
    add_reference :customers, :social_network, index: true
  end
end
