require_relative "constants"
require_relative "null_section"

module Elf
  class ObjectFile
    include Constants

    def initialize(target)
      @target = target

      @sections = []
      add_section NullSection.new
    end

    def add_section(section)
      @sections << section
      section.index = @sections.length - 1
    end

    def write(io)
      write_preamble(io)

      sh_offset_pos = io.tell

      write_header(io)

      string_table = write_string_table(io)

      io.write_uint16 @sections.length # section header count

      io.write_uint16 @sections.length-1 # section name string table index

      section_data = write_sections(io)

      sh_offset = io.tell

      write_section_data(section_data, string_table , io)

      io.seek sh_offset_pos
      io.write_uint32 sh_offset
    end

    def write_string_table(io)
      string_table = StringTableSection.new(".shstrtab")
      @sections << string_table
      @sections.each { |section|
        string_table.add_string section.name
      }
      string_table
    end

    def write_section_data(section_data, string_table,io)
      section_data.each { |data|
        section, offset, size = data[:section], data[:offset], data[:size]
        # write header first
        io.write_uint32 string_table.index_for(section.name)
        io.write_uint32 section.type
        io.write_uint32 section.flags
        io.write_uint32 section.addr
        if (section.type == SHT_NOBITS)
          raise 'SHT_NOBITS not handled yet'
        elsif (section.type == SHT_NULL)
          io.write_uint32 0
          io.write_uint32 0
        else
          io.write_uint32 offset
          io.write_uint32 size
        end
        io.write_uint32 section.link
        io.write_uint32 section.info
        io.write_uint32 section.alignment
        io.write_uint32 section.ent_size
      }
    end

    def write_sections(io)
      section_data = []
      @sections.each { |section|
        offset = io.tell
        section.write(io)
        size = io.tell - offset
        section_data << {:section => section, :offset => offset, :size => size}
      }
      section_data
    end

    def write_header(io)
      io.write_uint32 0 # section header table offset
      io.write_uint32 0 # no flags
      io.write_uint16 52 # header length
      io.write_uint16 0 # program header length
      io.write_uint16 0 # program header count
      io.write_uint16 40 # section header length
    end

    def write_preamble(io)
      io << "\x7fELF"
      io.write_uint8 @target[0]
      io.write_uint8 @target[1]
      io.write_uint8 EV_CURRENT
      io.write_uint8 @target[2]
      io << "\x00" * 8 # pad
      io.write_uint16 ET_REL
      io.write_uint16 @target[3]
      io.write_uint32 EV_CURRENT
      io.write_uint32 0 # entry point
      io.write_uint32 0 # no program header table
    end
  end
end
