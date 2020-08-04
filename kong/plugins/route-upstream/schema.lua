
-- The code for the schema below was copied from work done by Paula Murillo at
-- https://github.com/murillopaula/kong-upstream-by-header.git. I've
-- added comments that describe the schema.

local typedefs = require "kong.db.schema.typedefs"

---[[ This map allows for N header/value pairs to be specified in a rule]]
local headers_schema = {
  type = "map",
  required = true,
  keys = typedefs.header_name,
  values = { type = "string", }
}

---[[ This array allows a set of headers (the headers_schema map above)
-- to be paired with name of the upstream to which the request should be proxied.
local rules_schema = {
  type = "array",
  required = true,
  len_min = 1,
  elements = {
    type = "record",
    required = true,
    fields = {
      { headers = headers_schema, },
      { upstream_name = typedefs.host({ required = true }), },
    }
  }
}

---[[ The complete schema to be returned ]]
return {
  name = "route-upstream",
  fields = {
    {
      config = {
        type = "record",
        required = true,
        fields = {
          {
            rules = rules_schema,
          },
        },
      },
    },
  },
}