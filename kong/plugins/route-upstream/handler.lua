local kong = require "kong"


local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1",
}


function plugin:access(plugin_conf)
  plugin.super.access(self)

  local req_headers = kong.request.get_headers()

  local match, upstream
  local match_before, match_now = -1

  for _, rule in ipairs(plugin_conf.rules) do
    match = true
    match_now = 0

    for rule_header_name, rule_header_value in pairs(rule.headers) do
      if req_headers[rule_header_name] ~= rule_header_value then
        match = false
        break
      end

      match_now = match_now + 1
    end

    if match then
      upstream = match_now <= match_before and upstream or rule.upstream_name
      match_before = match_now
    end
  end

  kong.log.inspect(upstream)

  if upstream then
    kong.service.set_upstream(upstream)
    kong.response.set_header("X-Upstream-Name", upstream)
  end
end


return plugin
