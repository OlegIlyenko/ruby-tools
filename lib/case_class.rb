def case_class props
  Class.new do
    props.each do |k, _|
      attr_reader k

      define_method k do
        @props[k]
      end
    end

    define_method :defaults do
      props
    end

    def initialize inst_props
      missing = missing_keys inst_props
      raise "Can't instantiate #{self.class.name}. Keys are missing: #{missing}" unless missing.empty?

      @props = defaults.merge inst_props
    end

    def missing_keys hash
      defaults.select{|k, v| !hash.has_key?(k) && v.nil?}.map{|k, _| k}
    end

    def [](key)
      @props[key]
    end

    def copy overrides
      self.class.new @props.merge(overrides)
    end

    def to_s
      "#{self.class.name}(#{@props.select{|k, _| defaults.has_key? k}.map{|k, v| "#{k} = #{v.inspect}"}.join(", ")})"
    end

    private :missing_keys
  end
end

Person = case_class first_name: nil, last_name: nil, age: 10

p = Person.new first_name: "John", last_name: "Doe"

puts p
puts p.age
puts p.copy(age: 5)
puts p[:age]
puts p.age