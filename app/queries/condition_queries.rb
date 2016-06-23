module ConditionQueries

  def create_on_absence(id, args={})
    unless valid_hash(args).empty?
      find_or_create_by_hash(id, args)
    else
      find_or_create(id)
    end
  end

  def update_on_unequality(rec, args)
    valid_hash(args).each_pair do |col, val|
      self.update(rec, { col => val}) if valid_record(rec).send(col) != val
    end
  end

  private

  def find_or_create(id)
    unless self.exists?(id)
      record = self.create!
    else
      record = self.find(id)
    end
    return record
  end

  def find_or_create_by_hash(id, hash={})
    unless self.exists?(id)
      record = self.create!(hash)
    else
      record = self.find(id)
    end
    return record
  end

  def valid_record(record)
    unless record.is_a?(ActiveRecord::Base)
      throw arg_error("First", ActiveRecord::Base)
    end
    return record
  end

  def valid_id(id)
    unless id.is_a?(Number)
      throw arg_error("First", Number)
    end
    return id
  end

  def valid_hash(hash)
    unless hash.is_a?(Hash)
      throw arg_error("Second", Hash)
    end
    return hash
  end

  def arg_error(arg_num, type)
    ArgumentError.new("#{arg_num} argument has to be a valid #{type}")
  end
end
