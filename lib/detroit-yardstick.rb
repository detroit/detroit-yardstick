require 'detroit-standard'

module Detroit

  ##
  # Yardstick is a documentation coverage metric tool.
  # 
  # @assembly Standard
  #
  # @todo Switch to analyze station if detroit moves it after document.
  #
  class Yardstick < Tool

    # Designed to work with the Standard assembly attaching to the 
    # `post-document` station.
    #
    # @!parse
    #   include Standard
    #
    assembly Standard

    # Location of the manpage document for this tool.
    MANPAGE = File.dirname(__FILE__) + '/../man/detroit-yardstick.5'

    # Prerequisite setup.
    #
    # @return [undefined]
    def prerequisite
      require 'yardstick'

      @path    = 'lib/**/*.rb'
      @output  = project.log + 'yardstick.txt'
      @verbose = true
      @exact   = true
    end

    # List of paths to measure.
    #
    # @param [Array<#to_s>, #to_s] path
    #   optional list of paths to measure
    #
    # @return [String,Array<String>]
    attr_accessor :path

    # The path to the file where the measurements will be written.
    #
    # @param [String, Pathname] output
    #   optional output path for measurements
    #
    # @return [String]
    attr_accessor :output

    # return [Integer]
    attr_accessor :threshold

    # return [Boolean]
    attr_accessor :verbose

    # return [Boolean]
    attr_accessor :exact

    # @return [Hash]
    attr_accessor :rules

    # Measure the documentation and write to output.
    #
    # @example
    #   tool.save  # (save measurement report to output)
    #
    # @return [undefined]
    def save
      write_report { |io| ::Yardstick.measure(yard_config).puts(io) }
    end

    # Measure the documentation and write to stdout.
    #
    # @example
    #   tool.print  # (print measurement report to stdout)
    #
    # @return [undefined]
    def print
      ::Yardstick.measure(yard_config).puts($stdout)
    end

    # This tool ties into the `post_document` station of the standard assembly.
    #
    # @return [Boolean,Symbol]
    def assemble?(station, options={})
      return :save if station == :post_document
      return false
    end

  private

    #
    def yard_config
      Yardstick::Config.coerce(yard_options)
    end

    #
    def yardstick_options
      opts = {}

      opts[:path]      = path
      opts[:output]    = output
      opts[:verbose]   = verbose

      opts[:require_exact_threshold] = exact

      opts[:threshold] = threshold if threashold
      opts[:rules]     = rules     if rules

      return opts
    end

    # Open up a report for writing
    #
    # @yield [io]
    #   yield to an object that responds to #puts
    #
    # @yieldparam [#puts] io
    #   the object that responds to #puts
    #
    # @return [void]
    def write_report(&block)
      file = Pathname(output)
      file.dirname.mkpath
      file.open('w', &block)
    end

  end

end
