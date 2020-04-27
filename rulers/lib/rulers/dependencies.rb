# rulers/lib/rulers/dependencies.rb

class Object
  def self.const_missing(c)
    return nil if @const_missing_count > 0
    @const_missing_counts += 1
    require Rulers.to_underscore(c.to_s)
    klass = Object.const_get(c)
    @const_missing_counts = 0
    klass
  end
end
