class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def to_gender
    return 'male' if self =~ (/^(male|M|m|2)$/i)
    return 'female' if self =~ (/^(female|w|W|f|F|1)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
