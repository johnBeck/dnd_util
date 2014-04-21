module Dnd
  class Buffer2d
    WIDTH_INDEX = 0
    HEIGHT_INDEX = 1

    attr_accessor :buffer
    attr_accessor :dimensions

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
      x + (y * @dimensions[WIDTH_INDEX])
    end

    def in_buffer?(x, y)
      in_dimension(x, WIDTH_INDEX) && in_dimension(y, HEIGHT_INDEX)
    end

    def in_dimension(value, dimension_index)
      !!(value >= 0 && value < @dimensions[dimension_index])
    end

    def out_of_dimension(value, dimension_index)
      !!(value < 0 || value >= @dimensions[dimension_index])
    end

    def buffer_size
      @dimensions[WIDTH_INDEX] * @dimensions[HEIGHT_INDEX]
    end

    def write_string(x, y, value)
      return unless value
      value.chars.each_index do |i|
        put(x + i, y, value.chars[i])
      end
    end

    def write_horiz(x, y, data)
      data.size.times do |i|
        put(x + i, y, data[i])
      end
    end

    def write_vert(x, y, data)
      data.size.times do |i|
        put(x, y + i, data[i])
      end
    end

    def read_horiz(x, y, size)
      start_index = index(x, y)
      @buffer[start_index..(start_index + size)]
    end

    def read_vert(x, y, size)
      start_index = index(x, y)

      [].tap do |bytes|
        size.times do |i|
          bytes << get(x, y + i)
        end
      end
    end


    def max(a, b)
      a > b ? a : b
    end

    def min(a, b)
      a < b ? a : b
    end


  end
end
