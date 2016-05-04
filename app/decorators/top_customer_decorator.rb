class TopCustomerDecorator
  Account = Struct.new(:account, :count)

  def initialize(place)
    @place = place
  end

  def call
    visits = @place.visits.includes(:account).where(account_type: Auth.network_classes)

    visits.map do |visit|
      Account.new(
        visit.account,
        visits.where(account_type: visit.account_type, account_id: visit.account_id).count
      )
    end.uniq.sort_by { |v| v.count }
  end
end
