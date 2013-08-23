module FileAnalysis
  module SourceAnalyzer
    def init_info opts
      @file_path = opts[:file]
      @file_name = @file_path.split("/")[-1]
      @line_num = opts[:line]
      @col_num = opts[:col]
      @selected = opts[:selected]
    end

    def all_opts opts
      opts.merge file_path: @file_path, file_name: @file_name, line: @line_num, col: @col_num, sel: (@selected and @selected != '' ? @selected : nil), time: Time.now
    end

    def under_cursor(line, col_num)
      start = ""

      if m = /.*\b(?<start>[\w\d]+)$/.match(line[0 ... col_num])
        start = m[:start]
      end

      endTerm = ""

      if m = /^(?<e>[\w\d]+)\b.*/.match(line[col_num .. -1])
        endTerm = m[:e]
      end

      start + endTerm
    end
  end

  class AnyAnalyzer
    include SourceAnalyzer

    def initialize opts
      init_info opts

      open(@file_path).each_line.with_index do |line, idx|
        if idx == @line_num - 1
          @curr_line = line
          break
        end
      end

      @opts = all_opts(
          type: 'unknown',
          sub_type: 'line',
          id: @curr_line,
          unit_name: nil,
          id_under_cursor: under_cursor(@curr_line, @col_num),
          package: nil
      )
    end

    def analyze
      [@opts, "#{@opts[:type]} #{@opts[:sub_type]}: #{@opts[:id]}"]
    end

    def format
      nil
    end
  end

  class JavaAnalyzer
    include SourceAnalyzer

    def initialize opts
      init_info opts

      open(@file_path).each_line.with_index do |line, idx|
        if m = /public\s+(?<mod>class|interface)\s+(?<name>[\w\d]+)/.match(line)
          @java_type = m[:mod]
          @java_class_name = m[:name]
        end

        if m = /public\s+[\w\d]*?\s*(?<name>[\w\d]+)\(/.match(line)
          @java_last_method = m[:name]
        end

        if m = /package\s+(?<path>.*);/.match(line)
          @java_package = m[:path]
        end

        if idx == @line_num - 1
          @java_line = line
          break
        end
      end

      @java_id = if m = /private.*\s+(?<name>[\w\d]+?);/.match(@java_line)
                   m[:name]
                 end

      @opts = all_opts(
          type: 'java',
          sub_type: @java_id ? 'field' : 'method',
          id: @java_id || @java_last_method,
          unit_name: @java_class_name,
          id_under_cursor: under_cursor(@java_line, @col_num),
          package: @java_package
      )
    end

    def analyze
      [@opts, "#{@opts[:type]} #{@opts[:sub_type]}: #{@opts[:id]}"]
    end

    def format
      file = "#{@opts[:package]}.#{@opts[:unit_name]} (#{@opts[:line]}:#{@opts[:col]})"
      member = "#{@opts[:sub_type][0].upcase}#{@opts[:sub_type][1..-1]}: #{@opts[:id]}"
      sel = @opts[:sel] ? "Code:\n#{@opts[:sel]}" : nil

      [file, member, sel].join "\n"
    end
  end

  class SqlAnalyzer
    include SourceAnalyzer

    def initialize opts
      init_info opts

      open(@file_path).each_line.with_index do |line, idx|
        if m = /CREATE OR REPLACE FUNCTION\s+(?<name>[\w\d]+)\s*\(/.match(line)
          @sql_fn = m[:name]
        end

        if idx == @line_num - 1
          @sql_line = line
          break
        end
      end

      @sql_db = @file_path.split("/").drop_while{|part| part != 'database'}[1]

      @opts = all_opts(
          type: 'sql',
          sub_type: @sql_fn ? 'sproc' : 'other',
          id: @sql_fn || @file_name,
          unit_name: @file_name,
          id_under_cursor: under_cursor(@sql_line, @col_num),
          package: @sql_db
      )
    end

    def analyze
      [@opts, "#{@opts[:type]} #{@opts[:sub_type]}: #{@opts[:id]}"]
    end

    def format
      nil
    end
  end
end