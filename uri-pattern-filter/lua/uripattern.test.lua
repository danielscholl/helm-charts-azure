lu = require('luaunit')
require "uripatternfilter"

TestUriPatternFilter = {}

  function TestUriPatternFilter:TestSimpleMatch()
    local uriPatternList = { "/api/storage/v2/records/versions/{id}"}
    local pattern = getPattern("/api/storage/v2/records/versions/123:456:789", uriPatternList)
    lu.assertEquals(pattern, "/api/storage/v2/records/versions/{id}")    
  end

  function TestUriPatternFilter:Test_MustReturnOriginalUri_when_NoMathchingPattern()
    local uriPatternList = { "/api/storage/v2/records/versions/{id}"}
    local pattern = getPattern("/api/storage/v2/records/xxxxxxxxxxxx", uriPatternList)
    lu.assertEquals(pattern, "/api/storage/v2/records/xxxxxxxxxxxx")
  end

  function TestUriPatternFilter:Test_MustReturnUri_when_NoPlaceHolderpresentInUriPattern()
    local uriPatternList = { "/api/storage/v2/records/versions/test"}
    local pattern = getPattern("/api/storage/v2/records/test", uriPatternList)
    lu.assertEquals(pattern, "/api/storage/v2/records/test")
  end

  function TestUriPatternFilter:Test_MultiplePatternMatches()
    local uriPatternList = { "/api/storage/v2/records/versions/{id}", "/api/storage/v2/records/{id}/{version}"}    
    local pattern = getPattern("/api/storage/v2/records/versions/123:456:789", uriPatternList)    
    lu.assertEquals(pattern, "/api/storage/v2/records/versions/{id},/api/storage/v2/records/{id}/{version}")
  end

  function TestUriPatternFilter:Test_DDMS_Pattern_Matches()
    local uriPatternList = {
        "/seistore-svc/api/v3/svcstatus",
        "/seistore-svc/api/v3/svcstatus/access",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}/lock",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}/unlock",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}/permission",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}ctagcheck",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}/gtags",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/readdsdirfulllist",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/exist",
        "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/sizes",
        "/seistore-svc/api/v3/utility/ls",
        "/seistore-svc/api/v3/utility/storage-tiers",
        "/seistore-svc/api/v3/utility/cp",
        "/seistore-svc/api/v3/utility/gcs-access-token",
        "/seistore-svc/api/v3/utility/upload-connection-string",
        "/seistore-svc/api/v3/utility/download-connection-string",
        "/seistore-svc/api/v3/imptoken",
        "/seistore-svc/api/v3/subproject/tenant/{tenantid}/subproject/{subprojectid}",
        "/seistore-svc/api/v3/subproject/tenant/{tenantid}",
        "/seistore-svc/api/v3/tenant/{tenantid}",
        "/seistore-svc/api/v3/tenant/sdpath",
        "/seistore-svc/api/v3/user",
        "/seistore-svc/api/v3/user/roles",
        "/seistore-svc/api/v3/app",
        "/seistore-svc/api/v3/app/trusted",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/service-status",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/revision",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/is3D",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/traceHeaderFieldCount",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/textualHeader",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/extendedTextualHeaders",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/binaryHeaders",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/rawTraceHeaders",
        "/seistore-svc/api/v3/seismic-file-metadata/api/v1/segy/scaledTraceHeaders"
    }
    local pattern = getPattern("/seistore-svc/api/v3/dataset/tenant/723132-3231231-213213123/subproject/newproject", uriPatternList)    
    lu.assertEquals(pattern, "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}")
        
    pattern = getPattern("/seistore-svc/api/v3/dataset/tenant/723132-3231231-213213123/subproject/newproject123/exist", uriPatternList)    
    lu.assertEquals(pattern, "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/exist")

    pattern = getPattern("/seistore-svc/api/v3/dataset/tenant/723132-3231231-213213123/subproject/723132-213213123/dataset/d123123123123/permission", uriPatternList)    
    lu.assertEquals(pattern, "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}/permission")

    pattern = getPattern("/seistore-svc/api/v3/dataset/tenant/723132-3231231-213213123/subproject/723132-213213123/dataset/d123123123123/permission", uriPatternList)    
    lu.assertEquals(pattern, "/seistore-svc/api/v3/dataset/tenant/{tenantid}/subproject/{subprojectid}/dataset/{datasetid}/permission")
  end
return lu.LuaUnit.run()