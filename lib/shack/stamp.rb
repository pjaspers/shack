module Shack
  # Takes the body and adds a stamp to it, containing the supplied content.
  #
  # Takes some additional options to set the sha in the correct position
  #
  #      Stamp.new("html body", "123", {vertical: :left, horizontal: :right}).html
  #      # => HTML with the stamp set at the top left corner
  #
  class Stamp
    # body - original body
    # content - gets added to view
    # options - Either a hash or a Configuration instance
    def initialize(body, sha, options = {})
      @body = body
      @sha = sha || ""
      @short_sha = @sha[0..8]

      options = Configuration.new.to_hash.merge(options || {})
      @custom_content = options[:content] if options[:content]
      @vertical = options[:vertical]
      @horizontal = options[:horizontal]
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

    # Returns the CSS needed to round the correct corner
    #
    # `border-top-left-radius`
    def rounded_corner(horizontal, vertical)
      css = [] << "border"
      attrs = {
        top: "bottom", bottom: "top",
        left: "right", right: "left" }
      css << attrs.fetch(vertical)
      css << attrs.fetch(horizontal)
      css << "radius"
      css.join("-")
    end

    # Returns the CSS needed for positioning the stamp
    #
    # `position: fixed; top: 0; left: 0;`
    def position_css(horizontal, vertical)
      attrs = {
        top: "top: 0;", bottom: "bottom: 0;",
        left: "left: 0;", right: "right: 0;" }
      css = [] << "position: fixed;"
      css << attrs.fetch(vertical)
      css << attrs.fetch(horizontal)
      css.join("")
    end

    def html
      <<HTML
<style>
.sha-stamp {
  #{position_css(@horizontal, @vertical)}
  #{rounded_corner(@horizontal, @vertical)}: 5px;
  height: 16px;
  background: rgb(0, 0, 0) transparent; background-color: rgba(0, 0, 0, 0.2);
  padding: 0 5px;
  z-index: 2147483647; font-size: 12px;
}
.sha-stamp__content {
  text-align: center;
  color: white;
  font-family: "Lucida Console", Monaco, monospace;
  font-weight: normal;
  font-size: 12px;
  margin: 0;
}
.sha-stamp__content a {
  text-decoration: none;
  color: white;
}
</style>
<div id="shack-stamp" class="sha-stamp">
  <p id="shack-stamp__content" class="sha-stamp__content">#{content}</p>
</div>
HTML
    end
  end
end
