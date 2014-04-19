module Dnd
  class Util
  
    def initialize(path)
      read_map_from_file(path)
    end

    def render(level = 0)
      Renderer.new(@map_buffers[level]).render
    end

    def print_stats(level = nil)
      pp get_stats(level).map_keys(TILE_LOOKUP)
    end

    private

      def read_map_from_file(path)
        @map_buffers = []
        File.open(path, 'rb') do |file|
          DUNGEON_DEPTH.times do |level|
            @map_buffers << Buffer2d.new(LEVEL_SIDE, LEVEL_SIDE)
            @map_buffers[level].buffer = file.read(LEVEL_SIDE * LEVEL_SIDE).chars.map(&:ord)
          end
        end
      end

      def get_stats(level)
        buffers = level ? [@map_buffers[level]] : @map_buffers

        StatsBucket.new.tap do |special_tiles|
          buffers.each do |map_buffer|
            map_buffer.buffer.each do |value|
              special_tiles.count((value & TILE_BIT_MASK).to_s.intern)
            end
          end
        end
      end

  end
end
