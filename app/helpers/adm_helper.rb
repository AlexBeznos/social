module AdmHelper
  def thumb(active)
    active ? fa_icon('thumbs-o-up') : fa_icon('thumbs-o-down')
  end
end
