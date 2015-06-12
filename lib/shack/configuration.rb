module Shack
  # Used to configure the middleware
  class Configuration
    # The sha that should be displayed
    attr_accessor :sha

    # A string (can be html) that will be displayed in the UI
    attr_accessor :content

    # Boolean. Show or hide the samp
    attr_accessor :hide_stamp

    # Sets the vertical placement.
    # :top or : bottom (defaults to :bottom)
    attr_accessor :vertical

    # Sets the horizontal placement.
    # :left or :right (default to :right)
    attr_accessor :horizontal

    def initialize
      @vertical = :bottom
      @horizontal = :right
    end

    def hide_stamp?
      !!hide_stamp
    end
  end
end
