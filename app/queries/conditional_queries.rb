module ConditionalQueries
  def self.included base_class
    base_class.include RecordQueries
    base_class.extend ClassQueries
  end

  module RecordQueries
    def update_on_unequality(args = {})
      update valid_attributes(self, valid_hash!(args))
    end
  end

  module ClassQueries
    def create_on_absence(val, args = {}, &block)
      record = exists?(val) ? find_by_id_or_column(val) : create!(args)

      yield(rec) if block
      record
    end
  end

  private

  def find_by_id_or_column(val)
    val.is_a(Hash) ? find_by(val) : find(val)
  end

  def valid_attributes(record, args = {})
    args.map do |attribute, value|
      [attribute, value] unless record.send(attribute) == value
    end.compact.to_h
  end

  def valid_hash!(hash)
    unless hash.is_a?(Hash)
      throw ArgumentError.new("Second argument has to be a valid hash")
    end
    hash
  end
end
