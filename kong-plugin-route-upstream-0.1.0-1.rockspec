package = "kong-plugin-route-upstream"

version = "0.1.0-1"

local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "route-upstream"

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/kris-olberg/kongchallenge.git",
  tag = "0.1.0"
}

description = {
  summary = "Route to an upstream based on a configurable set of custom headers.",
  homepage = "https://github.com/kris-olberg/kongchallenge.git",
  license = "Apache 2.0"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
