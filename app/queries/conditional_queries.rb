module ConditionalQueries
  def self.included base_class
    base_class.include RecordQueries
    base_class.extend ClassQueries
  end

  module RecordQueries
    def update_on_unequality(args = {})
      update valid_attributes(self, valid_hash!(args))
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

  module ClassQueries
    def create_on_absence(args = {}, &block)
      record = exists?(args) ? find_by(valid_args(args)) : create!(valid_args(args))

      yield(record) if block 
      record
    end

    def valid_args(args)
      (args.is_a?(Hash) && args) || (args.is_a?(Integer) && {id: args}) || args
    end
  end
end
