module Dnd
  class StatsBucket
    attr_reader :hash

    def initialize
      @hash = {}
    end

    def count(key, amount = 1)
      @hash[key] ? @hash[key] += amount : @hash[key] = amount
    end

    def map_keys(key_mapping)
      {}.tap do |new_hash|
        @hash.each do |k, v|
          begin
            new_hash[key_mapping[k].intern] = v
          rescue
          end
        end
      end
    end

  end
end
