module Shack
  # Takes the body and adds a stamp to it, containing the supplied content.
  # At the moment, it's just a red div with white text.
  class Stamp
    # body - original body
    # content - gets added to view
    def initialize(body, sha, custom_content = nil)
      @body = body
      @sha = sha || ""
      @short_sha = @sha[0..8]
      @custom_content = custom_content if custom_content
    end

    # Only inject html on html requests, also avoid xhr requests
    #
    #       headers - Headers from a Rack request
    def self.stampable?(headers)
      !!(headers["Content-Type"] =~ %r{text/html}) &&
        !!(headers["HTTP_X_REQUESTED_WITH"] != "XMLHttpRequest")
    end

    def result
      @body.gsub!("</body>", html + "</body>")
      @body
    end

    def content
      if @custom_content
        c = @custom_content.gsub("{{sha}}", @sha)
        c.gsub!("{{short_sha}}", @short_sha)
        c
      else
        @sha
      end
    end

    def html
      <<HTML
<div id="sha-stamp" style="position: fixed; bottom: 0; right: 0; height: 16px; background: rgb(0, 0, 0) transparent; background-color: rgba(0, 0, 0, 0.2); padding: 0 5px; border-top-left-radius: 5px; z-index: 2147483647; font-size: 12px;">
  <span style="text-align: center;">
    <small style="color: white; font-weight: normal;font-size: 12px;">#{content}</small>
  </span>
</div>
HTML
    end
  end
end
