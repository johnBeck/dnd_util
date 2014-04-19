require 'pp'

require './dnd_util.rb'
require './dnd_map_tile.rb'
require './dnd_buffer_2d.rb'
require './dnd_renderer.rb'
require './dnd_stats_bucket.rb'

module Dnd
  LEVEL_SIDE =     20
  DUNGEON_DEPTH =  20
  TILE_SIDE =      4
  RASTER_SIDE =    (TILE_SIDE * LEVEL_SIDE) + 1
  TERMINAL_WIDTH = 80

  HORIZONTAL_BIT_MASK = 0xC
  VERTICAL_BIT_MASK =   0x3
  TILE_BIT_MASK =       0xF0

  FLOOR_CHAR =        ' '
  WALL_CHAR =         'I'
  DOOR_HORIZ_CHAR =   '-'
  DOOR_VERT_CHAR =    '|'
  SECRET_HORIZ_CHAR = '.'
  SECRET_VERT_CHAR =  ':'

  WALL_MAPPING = {
    :"4"  => WALL_CHAR,
    :"8"  => DOOR_HORIZ_CHAR,
    :"12" => SECRET_HORIZ_CHAR,
    :"1"  => WALL_CHAR,
    :"2"  => DOOR_VERT_CHAR,
    :"3"  => SECRET_VERT_CHAR
  }

  TILE_LOOKUP = {
    # :'0' => 'FLOOR',
    :'16'  => 'DN',
    :'32'  => 'UP',
    :'48'  => 'SP',
    :'64'  => 'EXC',
    :'80'  => 'PIT',
    :'96'  => 'TPT',
    :'112' => 'FNT',
    :'128' => 'ALT',
    :'144' => 'DGN',
    :'160' => 'ORB',
    :'176' => 'MIR',
    :'192' => 'ELV',
    :'208' => '$',
    :'224' => 'TRV',
    :'240' => 'GNI'
  }

end
