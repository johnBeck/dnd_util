module Dnd
  class PlayerUtil
    BYTE_LENGTH = 1
    WORD_LENGTH = 2
    DWORD_LENGTH = 4

    BLANK_TEXT_CHAR = 32.chr

    ATTRIBUTE_INFO = {
      name: { offset: 0, length: 16, type: :text },
      password: { offset: 16, length: 16, type: :text },

      #stats: { offset: 32, length: 6, type: :byte }, # one byte each, STR, INT, WIS, CON, DEX, CHA
      str: { offset: 32, length: 1, type: :byte },
      int: { offset: 33, length: 1, type: :byte },
      wis: { offset: 34, length: 1, type: :byte },
      con: { offset: 35, length: 1, type: :byte },
      dex: { offset: 36, length: 1, type: :byte },
      cha: { offset: 37, length: 1, type: :byte },

      level: { offset: 40, length: 1, type: :word },

      exp: { offset: 42, length: 1, type: :dword },

      hp: { offset: 46, length: 1, type: :word },
#      hp: { offset: 48, length: 1, type: :word },

      gold: { offset: 54, length: 1, type: :dword },

      cloak: { offset: 66, length: 1, type: :word },
      boots: { offset: 68, length: 1, type: :word },
      ring: { offset: 70, length: 1, type: :word },
      shield: { offset: 72, length: 1, type: :word },
      armor: { offset: 74, length: 1, type: :word },
      weapon: { offset: 76, length: 1, type: :word },

      spell_1_max: { offset: 78, length: 1, type: :word },
      spell_2_max: { offset: 80, length: 1, type: :word },
      spell_3_max: { offset: 82, length: 1, type: :word },
      spell_4_max: { offset: 84, length: 1, type: :word },

      spell_1_temp: { offset: 86, length: 1, type: :word },
      spell_2_temp: { offset: 88, length: 1, type: :word },
      spell_3_temp: { offset: 90, length: 1, type: :word },
      spell_4_temp: { offset: 92, length: 1, type: :word },

      orb_finder: { offset: 116, length: 1, type: :word },


    }

    # CLASS_OFFSET

    # DUNGEON_OFFSET

    # SPELLS_LVL1
    # SPELLS_LVL2
    # SPELLS_LVL3
    # SPELLS_LVL4


    # 42, 54 could be EXP or GOLD (4 bytes?)

    # EXP_OFFSET
    # GOLD_OFFSET

    # LEVEL_OFFSET

    # ARMOR_OFFSET
    # RING_OFFSET
    # CLOAK_OFFSET = 66 :word?
    # WEAPON_OFFSET
    # BOOTS_OFFSET
    # SHIELD_OFFSET


    # CURRENT_HP = 45 # ???
    # MAX_HP = 47 # ???


    def initialize(path)
      File.open(path, 'rb') do |file|
        num_players = file.size / PLAYER_LENGTH
        @players = Buffer2d.new(num_players, PLAYER_LENGTH, nil)
        num_players.times do |x|
          player = file.read(PLAYER_LENGTH).chars
          @players.write_vert(x, 0, player)
        end

        puts "Players file contains #{num_players} players."

        # modify_attribute(4, ATTRIBUTE_INFO[:name], 'sheeit')
        # modify_attribute(4, ATTRIBUTE_INFO[:exp], 100000)

        modify_attribute(4, ATTRIBUTE_INFO[:hp], 13200)

        modify_attribute(4, ATTRIBUTE_INFO[:level], 25)

        modify_attribute(4, ATTRIBUTE_INFO[:shield], 72)
        modify_attribute(4, ATTRIBUTE_INFO[:cloak], 72)
        modify_attribute(4, ATTRIBUTE_INFO[:boots], 72)
        modify_attribute(4, ATTRIBUTE_INFO[:ring], 72)
        modify_attribute(4, ATTRIBUTE_INFO[:weapon], 72)
        modify_attribute(4, ATTRIBUTE_INFO[:armor], 72)

        modify_attribute(4, ATTRIBUTE_INFO[:str], 32)
        modify_attribute(4, ATTRIBUTE_INFO[:int], 32)
        modify_attribute(4, ATTRIBUTE_INFO[:wis], 32)
        modify_attribute(4, ATTRIBUTE_INFO[:con], 32)
        modify_attribute(4, ATTRIBUTE_INFO[:dex], 32)
        modify_attribute(4, ATTRIBUTE_INFO[:cha], 32)

        compare
        print_by_attribute

        save_players
      end
    end

    def compare(player_indices = nil)
      puts "Comparing: #{player_indices}"

      if player_indices.nil?
        player_indices = []
        @players.dimensions[Buffer2d::WIDTH_INDEX].times do |pi|
          player_indices << pi
        end
      end

      PLAYER_LENGTH.times do |i|
        ords = [i]
        player_indices.size.times do |pi|
          ords << @players.get(player_indices[pi], i).ord
        end
        puts "%-4d: #{'%-4d' * player_indices.size}" % ords
      end
    end

    def print_by_attribute
      ATTRIBUTE_INFO.each do |key, attribute|
        puts "\n #{key.to_s} ------\n\n"
        values = interpret_attribute(attribute)

        if !values.empty?
          values[0].size.times do |i|
            puts "#{values.map{ |attribute| attribute[i] }.join(' ')}"
          end
        end
      end
    end

    def interpret_attribute(attribute)
      [].tap do |values|
        @players.dimensions[Buffer2d::WIDTH_INDEX].times do |pi|
          value = []

          case attribute[:type]
          when :text
            attribute[:length].times do |i|
              value << @players.get(pi, attribute[:offset] + i)
            end
          when :byte
            attribute[:length].times do |i|
              value << "%-4d" % @players.get(pi, attribute[:offset] + i).ord
            end

          when :word
            value = []
            attribute[:length].times do |i|

              word = 0
              WORD_LENGTH.times do |j|
                byte = @players.get(pi, attribute[:offset] + i + j).ord
                word += byte << (j * 8)
              end

              value << "%-9d" % word
            end

          when :dword
            value = []
            attribute[:length].times do |i|

              dword = 0
              DWORD_LENGTH.times do |j|
                byte = @players.get(pi, attribute[:offset] + i + j).ord
                dword += byte << (j * 8)
              end

              value << "%-12d" % dword
            end
          end
          values << value
        end
      end
    end

    def modify_attribute(player_index, attribute, value)
      # TODO: longer than length: 1 non-text attibutes

      case attribute[:type]
      when :text
        text = value.split('')[0..attribute[:length] - 1]
        if text.size < attribute[:length]
          (attribute[:length] - text.size).times{ text << BLANK_TEXT_CHAR }
        end
        @players.write_vert(player_index, attribute[:offset], text)
      when :byte
        @players.put(player_index, attribute[:offset], value.chr)
      when :word
        WORD_LENGTH.times do |i|
          byte = (value >> (i * 8)) & 0xFF
          @players.put(player_index, attribute[:offset] + i, byte.chr)
        end
      when :dword
        DWORD_LENGTH.times do |i|
          byte = (value >> (i * 8)) & 0xFF
          @players.put(player_index, attribute[:offset] + i, byte.chr)
        end

      end
    end

    def save_players
      File.open(BASE_PATH + PLAYERS_OUTPUT_PATH, 'w') do |file|
        @players.dimensions[Dnd::Buffer2d::WIDTH_INDEX].times do |pi|
          file.write(@players.read_vert(pi, 0, PLAYER_LENGTH).map(&:ord).pack('C*'))
        end
      end
    end
  end
end
