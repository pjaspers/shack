module Shack
  # Takes the body and adds a stamp to it, containing the supplied content.
  # At the moment, it's just a red div with white text.
  class Stamp
    # body - original body
    # content - gets added to view
    def initialize(body, content)
      @body = body
      @content = content
    end

    def self.stampable?(headers)
      !!(headers["Content-Type"] =~ %r{text/html})
    end

    def result
      @body.gsub!("</body>", html + "</body>")
      @body
    end

    def html
      <<HTML
<div id="sha-stamp" style="position: fixed; bottom: 0; right: 0; height: 13px; background-color: darkred; padding: 0 5px;">
  <span style="text-align: center; color: white; font-weight: normal;font-size: 12px">
    <small>#{@content}</small>
  </span>
</div>
HTML
    end
  end
end
