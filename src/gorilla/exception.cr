require "./syntax/location.cr"
require "./syntax/ast.cr"
require "./source-highlight.cr"
require "./interpreter/context.cr"
require "colorize"

module Charly

  class BaseException < Exception
    def to_s(io)
      meta(io)
      io << "#{@message}".colorize(:red)
    end

    private def meta(io)
    end
  end

  class LocalException < BaseException
    property location_start : Location
    property location_end : Location
    property source : String
    property filename : String
    property trace : Array(Trace)

    def initialize(@location_start, @location_end, @message, @trace = [] of Trace)
      path = @location_start.filename

      if path.starts_with? Dir.current
        @filename = File.join(".", path.gsub(Dir.current, ""))
      else
        @filename = path
      end

      if File.exists?(path) && File.readable?(path)
        @source = File.read(path)
      else
        @source = ""
      end
    end

    def self.new(location_start : Location, message : String)
      self.new(location_start, location_start, message, [] of Trace)
    end

    def self.new(location_start : Location, location_end : Location, message : String)
      self.new(location_start, location_end, message, [] of Trace)
    end

    def self.new(node : ASTNode, message : String)
      self.new(node.location_start, node.location_end, message, [] of Trace)
    end

    def self.new(node : ASTNode, context : Context, message : String)
      self.new(node.location_start, node.location_end, message, context.trace)
    end

    private def meta(io)
      io << @filename.colorize(:yellow)
      io << "\n"

      highlighter = SourceHighlight.new(@location_start, @location_end)
      highlighter.present(source, io)

      @trace.each do |entry|
        io << "#{entry.colorize(:green)}\n"
      end
    end
  end

  class SyntaxError < LocalException
  end

  class RunTimeError < LocalException
  end

  class UnlocatedRunTimeError < BaseException
    property trace : Array(Trace)

    def initialize(@message : String, @trace)
    end

    private def meta(io)
      @trace.each do |entry|
        io << "#{entry.colorize(:green)}\n"
      end
    end
  end
end