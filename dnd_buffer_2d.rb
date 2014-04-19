module Dnd
  class Buffer2d
    attr_accessor :buffer

    def initialize(width, height, default_value = nil)
      @dimensions = [width, height]
      clear(default_value)
    end

    def put(x, y, value)
      @buffer[index(x, y)] = value if in_buffer?(x, y)
    end

    def get(x, y)
      in_buffer?(x, y) ? @buffer[index(x, y)] : nil
    end

    def clear(value = nil)
      @buffer = Array.new(buffer_size, value)
    end

    def index(x, y)
      x + (y * @dimensions[0])
    end

    def in_buffer?(x, y)
      (x >= 0 && x < @dimensions[0]) && (y >= 0 && y < @dimensions[1])
    end

    def buffer_size
      @dimensions[0] * @dimensions[1]
    end

    def write_string(x, y, value)
      return unless value
      value.chars.each_index do |i|
        put(x + i, y, value.chars[i])
      end
    end

  end
end
