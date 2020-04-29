# rulers/lib/rulers/dependencies.rb

class Object
  def self.const_missing(c)
    @calling_const_missing ||={}
    return nil if @calling_const_missing[c]
    require Rulers.to_underscore(c.to_s)
    @calling_const_missing[c] = true
    klass = Object.const_get(c)
    @calling_const_missing[c] = 0

    klass
  end
end
