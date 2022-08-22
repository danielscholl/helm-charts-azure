# URI-Pattern-Filter

## Introduction
This Envoyfilter is used to parse the URI Paths, match them against configured patterns, and then emit the pattern in a header.

The value of that header i.e., the URI Pattern, is later used by ISTIO as a metric value for the dimension "request_path"

**Example:**

Consider the 2 paths:
1. /api/storage/v2/records/123-456-789-012
2. /api/storage/v2/records/abc-xyz-13-asdasd

Without this filter, there will be two different metric timeseries due to the two dimensions:

    istio_requests_total{app="storage", request_url_path="/api/storage/v2/records/123-456-789-012"} **1**
    istio_requests_total{app="storage", request_url_path="/api/storage/v2/records/abc-xyz-13-asdasd"} **1**

If there are a billion record IDs, there will be a billion different timeseries, which will be a HIGE resource drain to prometheus and also geneva. This is simply not practical.

With this filter, these paths will be matched against the following pattern taht's configured:
    **/api/storage/v2/records/{recordid}**
and if it matches, the pattern will  be inserted into a **response header** called **x-internal-uri-pattern**. THe value of this header is picked up by ISTIO while emitting metrics (configured in the istio-stats-* filter).

The metric will have 1 time series now, as below:

    istio_requests_total{app="storage", request_url_path="/api/storage/v2/records/{recordId}"} **2**


## Usage - How to configure a service to use this EnvoyFilter

Add this chart as a dependency. In your application's **Chart.yaml**, add this:-

    dependencies:
    - name: "uri-pattern-filter"
        version: "0.1.0"
        repository: file://../uri-pattern-filter #relative path
        enabled: true


In your application chart's **values.yaml** file, add the configuration for the uri-pattern-filter. 

Two Configurations:
1. **appLabel** - This is the label of the app for which this ENvoyFilter has to be configured.
2. **uriPatterns** - A list of URL patterns

Sample Config is below

    uri-pattern-filter:
        appLabel: storage
        uriPatterns:
        - "/api/storage/v2/records/versions/{id}"
        - "/api/storage/v2/records/{id}/{version}"
        - "/api/storage/v2/records/{record-id}:delete"
        - "/api/storage/v2/records/{record-id}"

For URIs that don't have a pattern i.e., if they are static without any placeholders, then there is no need to add them to the uriPatterns list; the filter adds the full URI if it is unable to match it against any configured pattern.

That's it.

## Testing - How to run and write unit tests for the Lua script used for the filter
In the folder **Lua**, the file *.test.lua contains the unit tests. To run the unit tests, follow the below steps:

1. Install Lua, LuaJIT, LuaRocks and LuaUnit
   1. To do This, follow this guide for Lua, LuaJIT and LuaRocks - https://github.com/lua-rocks/install-lua
   2. Afte the above steps, install LuaUnit by runing the following commands:
      1. sudo luarocks install luaunit

2. Navigate to the folder containing the *.test.lua files
3. run "lua uripattern.test.lua"