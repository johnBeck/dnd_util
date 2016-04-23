module Dnd
  class MapTile
    def self.draw(x, y, value, render_buffer)
      i = x * TILE_SIDE
      j = y * TILE_SIDE

      draw_vertical_wall(i, j, value, render_buffer)
      draw_horizontal_wall(i, j, value, render_buffer)
      draw_tile_label(i, j, value, render_buffer)
    end

    private
      def self.draw_horizontal_wall(i, j, value, render_buffer)
        door_char = WALL_MAPPING[(value & HORIZONTAL_BIT_MASK).to_s.intern]
        return if door_char.nil?
        render_buffer.put(i, j, WALL_CHAR)
        render_buffer.put(i + TILE_SIDE, j, WALL_CHAR)
        (TILE_SIDE - 1).times do |a|
          render_buffer.put(i + a + 1, j, door_char)
        end
      end

      def self.draw_vertical_wall(i, j, value, render_buffer)
        door_char = WALL_MAPPING[(value & VERTICAL_BIT_MASK).to_s.intern]
        return if door_char.nil?
        render_buffer.put(i, j, WALL_CHAR)
        render_buffer.put(i, j + TILE_SIDE, WALL_CHAR)
        (TILE_SIDE - 1).times do |a|
          render_buffer.put(i, j + a + 1, door_char)
        end
      end

      def self.draw_tile_label(i, j, value, render_buffer)
        masked_value = value & TILE_BIT_MASK
        render_buffer.write_string(i + 1, j + 2, TILE_LOOKUP[masked_value.to_s.intern])
      end
  end
end
