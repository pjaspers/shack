## 0.0.4

- Broke the railtie if you wanted to specify your own sha.

## 0.0.3

- Don't show shack on print pages.
- Expose sha for easy access from app. (`Shack.sha`)
- Allow placement of sha from the config

```
Shack::Middleware.configure do |shack|
  shack.horizontal = :left # or :right
  shack.vertical = :top # or :bottom
 end
```
- Add ability to override CSS styles (use `#sha-stamp`)
- Add quick way to fire up demo server (`rake demo`)
- Don't inject on XHR requests.

## 0.0.2

- Expose `{{short_sha}}` in custom content block. - 6180bbc
- Fix: Now sets z-index to ridiculously high message - 4a87296
- Fix: Firefox not showing the stamp - a16d8f6

## 0.0.1

Initial release
