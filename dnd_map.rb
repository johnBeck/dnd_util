require './dnd.rb'

base_path = 'c:\\dosbox\\dnd_12\\'

telengard_path = 'TELENARD.BIN'
cavern_path = 'CAVERN.BIN'
lamorte_path = 'LAMORTE.BIN'
shvenk_path = 'SHVENK.BIN'
warren_path = 'WARREN.BIN'

level = ARGV[0] ? ARGV[0].to_i - 1 : 0

dnd_util = Dnd::Util.new(base_path + cavern_path)
dnd_util.render(level)
dnd_util.print_stats(level)
