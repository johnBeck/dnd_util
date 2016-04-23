module Dnd
  class MapRenderer
    def initialize(map_buffer)
      @map_buffer = map_buffer
    end

    def render
      rasterize_map
      print_map
    end

    private
      def rasterize_map
        @render_buffer = Buffer2d.new(RASTER_SIDE, RASTER_SIDE, FLOOR_CHAR)
        fill_in_far_edges
        draw_map_tiles
      end

      def fill_in_far_edges
        RASTER_SIDE.times do |i|
          @render_buffer.put(RASTER_SIDE - 1, i, WALL_CHAR)
          @render_buffer.put(i, RASTER_SIDE - 1, WALL_CHAR)
        end
      end

      def draw_map_tiles
        LEVEL_SIDE.times do |j|
          LEVEL_SIDE.times do |i|
            MapTile.draw(i, j, @map_buffer.get(i, j), @render_buffer)
          end
        end
      end

      def print_map
        width = RASTER_SIDE > TERMINAL_WIDTH ? TERMINAL_WIDTH : RASTER_SIDE
        RASTER_SIDE.times do |j|
          width.times do |i|
            print @render_buffer.get(i, j)
          end
          puts if width < TERMINAL_WIDTH
        end
      end
  end
end
