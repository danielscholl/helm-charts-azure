function getPattern(uriPath, patternlist)
  local pathWithoutQueryParams = ""
  for token in string.gmatch(uriPath, "[^?]+") do
    pathWithoutQueryParams = token
    break
  end
  if string.sub(pathWithoutQueryParams, -1, -1) == "/" then
    pathWithoutQueryParams=string.sub(pathWithoutQueryParams, 1, -2)
  end
  local matchingPatterns = {}
  for i = 1 , #(patternlist) do
    local entry = patternlist[i]
    local regPattern = string.gsub(entry, "%-","%%-")
    regPattern = string.gsub(regPattern, "{.-}", "[^/]+")
    regPattern = regPattern .. "$"
    if string.find(pathWithoutQueryParams, regPattern) then
      table.insert(matchingPatterns, entry)
    end
  end
  if(#(matchingPatterns) == 0) then
      return pathWithoutQueryParams
  else
      return table.concat(matchingPatterns,",")
  end
end
function envoy_on_request(request_handle)
  local fullPath = request_handle:headers():get(":path")
  local pattern = getPattern(fullPath, uriPatternList)
  request_handle:streamInfo():dynamicMetadata():set("envoy.lua.uri-pattern-matcher", "uri-pattern", pattern)
end
function envoy_on_response(response_handle)
  local pattern = response_handle:streamInfo():dynamicMetadata():get("envoy.lua.uri-pattern-matcher")["uri-pattern"]
  response_handle:headers():replace("x-internal-uri-pattern", pattern)
end