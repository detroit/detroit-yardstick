require 'detroit/tool'

module Detroit

  # Yardstick tool.
  def Yardstick(options={})
    Yardstick.new(options)
  end

  # TODO: Switch to analyze station if detroit moves it after document.

  # Yardstick service.
  #
  class Yardstick < Tool

    # List of paths to measure
    #
    # @param [Array<#to_s>, #to_s] path
    #   optional list of paths to measure
    #
    # @return [undefined]
    #
    # @api public
    attr_accessor :path

    # The path to the file where the measurements will be written
    #
    # @param [String, Pathname] output
    #   optional output path for measurements
    #
    # @return [undefined]
    #
    # @api public
    attr_accessor :output

    # Initialize attribute defaults.
    #
    # @return [undefined]
    #
    # @api public
    def initialize_defaults
      @path   = 'lib/**/*.rb'
      @output = project.log + 'yardstick.txt'
    end

    # Measure the documentation and write to output.
    #
    # @example
    #   tool.save  # (save measurement report to output)
    #
    # @return [undefined]
    #
    # @api public
    def save
      write_report { |io| ::Yardstick.measure(path).puts(io) }
    end

    # Measure the documentation and write to stdout.
    #
    # @example
    #   tool.print  # (print measurement report to stdout)
    #
    # @return [undefined]
    #
    # @api public
    def print
      ::Yardstick.measure(path).puts($stdout)
    end

    #  A S S E M B L Y  M E T H O D S

    # Detroit station for yardstick measure is post-document.
    #
    # @api public
    def assemble?(station, options={})
      case station
      when :post_document then true
      end
    end

    # Detroit station for yardstick measure is post-document.
    #
    # @api public
    def assemble(station, options={})
      case station
      when :post_document
        save
      end
    end

    # Path to to man-page document.
    def self.man_page
      File.dirname(__FILE__)+'/../man/detroit-yardstick.5'
    end

  private

    # Open up a report for writing
    #
    # @yield [io]
    #   yield to an object that responds to #puts
    #
    # @yieldparam [#puts] io
    #   the object that responds to #puts
    #
    # @return [undefined]
    #
    # @api private
    def write_report(&block)
      file = Pathname(output)
      file.dirname.mkpath
      file.open('w', &block)
    end

    #
    def initialize_require
      #require 'pathname'
      require 'yardstick'
    end

  end

end
