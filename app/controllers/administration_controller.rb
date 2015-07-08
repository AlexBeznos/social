class AdministrationController < ApplicationController
  layout 'admin'

  def current_ability
    @current_ability ||= AdmAbility.new(current_user)
  end
end
