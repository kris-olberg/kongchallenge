-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

assert(ngx.get_phase() == "timer", "The world is coming to an end!")


local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1",
}


local kong = kong

---[[ handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()

  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")

end --]]


---[[ runs in the 'access_by_lua_block'
-- the code for the function below was copied from work done by Paula Murillo at
-- https://github.com/murillopaula/kong-upstream-by-header.git. I've
-- added comments that describe the algorithm.
function plugin:access(plugin_conf)
  plugin.super.access(self)

  ---[[ get the headers and values; e.g, X-Country=Italy]]
  local req_headers = kong.request.get_headers()

  ---[[ set local variables for logic eval, counters and the upstream name ]]
  local match, upstream
  local match_before, match_now = -1

  ---[[ for each rule in config rules assume the request and rule headers match ]]
  for _, rule in ipairs(plugin_conf.rules) do
    match = true
    match_now = 0

    ---[[ verify whether they match by comparing each header value in the request
    -- with each header value in the CURRENT rule ]]
    for rule_header_name, rule_header_value in pairs(rule.headers) do
      if req_headers[rule_header_name] ~= rule_header_value then
        ---[[ if no match, set "match" to false and start again with the next header in the rule ]]
        match = false
        break
      end

      ---[[ increment local variable to count the number of request/rule header matches ]]
      match_now = match_now + 1
    end

    ---[[ if match has not been set to false, set the upstream value ]]
    if match then
      ---[[ set upstream to upstream if the number of matches is less than or equal to match_before.
      -- If not, set upstream to the upstream_name in the CURRENT rule. This has the effect of
      -- selecting the upstream_name from the rule with the greatest number of header request/rule
      -- matches ]]
      upstream = match_now <= match_before and upstream or rule.upstream_name
      match_before = match_now
    end
  end

  kong.log.inspect(upstream)

  ---[[ upstream began life as a nil, so if no matches were made, upstream evaluates to false
  -- and no X-Upstream-Name header will be set on the request. If a match were made, 
  -- upstream will be true and the X-Upstream-Name header will be set to the value of upstream. ]]
  if upstream then
    kong.service.set_upstream(upstream)
    kong.response.set_header("X-Upstream-Name", upstream)
  end
end --]]


---[[ runs in the 'header_filter_by_lua_block'
function plugin:header_filter(plugin_conf)

  -- your custom code here, for example;
  ngx.header[plugin_conf.response_header] = "this is on the response"

end --]]


-- return our plugin object
return plugin
