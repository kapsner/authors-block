local List = require 'pandoc.List'
local utils = require 'pandoc.utils'
local stringify = utils.stringify

-- [import]
local from_scholarly = require "from_scholarly_metadata"
local resolve_institutes = from_scholarly.resolve_institutes
-- [/import]

local M = {}

-- from @kapsner
local function normalize_affiliations(affiliations)
  local affiliations_norm = List:new(affiliations):map(
    function(affil, i)
      affil.index = pandoc.MetaInlines(pandoc.Str(tostring(i)))
      affil.id = pandoc.MetaString(stringify(affil.id))
      return affil
    end
  )
  return affiliations_norm
end
M.normalize_affiliations = normalize_affiliations


-- from https://stackoverflow.com/a/2282547
local function has_key(set, key)
  return set[key] ~= nil
end
M.has_key = has_key

-- from @kapsner
local function normalize_authors(affiliations)
  return function(auth)
    auth.id = pandoc.MetaString(stringify(auth.name))
    auth.affiliations = resolve_institutes(
      auth.affiliations,
      affiliations
    )
    return auth
  end
end
M.normalize_authors = normalize_authors

return M
