#  WKRequest

All your API requests should go through `WKRequest`.  Here's the parameter list. 

### Path
`String` - The URL or path to call.  

### Method
`Enum ` - The HTTP method for this specific endpoint.  Available values are:

* .get
* .post
* .put
* .delete

### Query Params
`[String: String]` - A set of query parameters to append to your URL


### Body
`[String: String]` - Dictionary to be sent as the request body.  WireKit provides an `asDictionary` extension method to convert any Codable object into a valid dictionary.

### Headers
`[String: String]` - Dictionary of headers to be sent.  By default Wirekit automatically adds `Content-Type` and `Accept` headers so you don't have to manually addd them here.

