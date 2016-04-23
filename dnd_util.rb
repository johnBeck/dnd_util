require './dnd/dnd.rb'

module Dnd
  class Util
  end
end

level = ARGV[0] ? ARGV[0].to_i - 1 : 0

dnd_util = Dnd::MapUtil.new(Dnd::BASE_PATH + Dnd::SHVENK_PATH)
dnd_util.render(level)
dnd_util.print_stats(level)

dnd_player_util = Dnd::PlayerUtil.new(Dnd::BASE_PATH + Dnd::PLAYERS_PATH)
