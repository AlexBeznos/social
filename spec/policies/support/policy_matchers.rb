RSpec::Matchers.define :permit_crud do
  match do |policy|
    policy.index?&&
    policy.new?&&
    policy.create?&&
    policy.show?&&
    policy.edit?&&
    policy.update?&&
    policy.destroy?
  end

  description do
    "permit index,new,create,edit,update,destroy"
  end
end


RSpec::Matchers.define :permit_place_additional_actions do
  match do |policy|
    policy.download_settings?&&
    policy.settings?&&
    policy.guests?&&
    policy.birthdays?
  end

end
