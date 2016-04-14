class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  Ahoy.visit_duration = 5.minutes

  def visit_model
    AhoyVisit
  end

  def track_visit(options)
    super do |visit|
      visit.place = Place.find_by_slug(controller.params[:slug])
      visit.customer = controller.current_customer
    end
  end
end
