module Shack
  # Takes the body and adds a stamp to it, containing the supplied content.
  # At the moment, it's just a red div with white text.
  class Stamp
    # body - original body
    # content - gets added to view
    def initialize(body, sha, custom_content = nil)
      @body = body
      @sha = sha
      @custom_content = custom_content if custom_content
    end

    def self.stampable?(headers)
      !!(headers["Content-Type"] =~ %r{text/html})
    end

    def result
      @body.gsub!("</body>", html + "</body>")
      @body
    end

    def content
      if @custom_content
        @custom_content.gsub("{{sha}}", @sha)
      else
        @sha
      end
    end

    def stamp_style
      {
        position: "fixed",
        bottom: 0,
        right: 0,
        height: "16px",
        background: "rgb(0, 0, 0) transparent",
        "background-color" => "rgba(0, 0, 0, 0.6)",
        padding: "0 5 x"
      }.collect { |k, v| "%s: %s;" % [k, v] }.join(" ")
    end

    def html
      <<HTML
<div id="sha-stamp" style="#{stamp_style}">
  <span style="text-align: center;">
    <small style="color: white; font-weight: normal;font-size: 12px;">#{content}</small>
  </span>
</div>
HTML
    end
  end
end
