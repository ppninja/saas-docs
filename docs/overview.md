## Overview

This describes the resources that make up the official PPJ API v1. If you have any problems or requests please contact [support](mailto:ypzhao@ppj.io).



### Current Version

This document describes the official version of PPJ API v1. We require you to explicitly request this version via the `Accept` header.

`Accept: application/vnd.ppj.v1+json`

### Gateway

`http://api.ppj.io/`

### Schema

All API access is over HTTPS, and accessed from the `https://api.ppj.io`. All data is sent and received as JSON.

``` unix
curl -i
```

Blank fields are included as `null` instead of being omitted.

All timestamps are returned in ISO 8601 format, except in some cases Unix timestamp is used and stated explicitly:

ISO 8601: `YYYY-MM-DDTHH:MM:SSZ // e.g. 2017-03-16T02:20:39+00:00`

Unix timestamp: `1489804788 // represents timestamp at 2017-03-18T10:39:48+08:00 `


### Client Errors

There are three possible types of client errors on API calls that receive request bodies:

1. Sending invalid JSON will result in a `400 Bad Request` response.
{% response header='400 Bad Request' %}
{
  "message": "Problems parsing JSON"
}
{% endresponse %}

2. Sending the wrong types of JSON values will result in a `400 Bad Request` response.
{% response header='400 Bad Request' %}
{
  "message": "Body should be a JSON object"
}
{% endresponse %}

3. Sending invalid fields will result in a `422 Unprocessable Entity` response.
{% response header='422 Unprocessable Entity' %}
{
  "message": "Validation Failed",
  “errors”: [
    {
      "resource": "Job",
      "field": "file_md5",
      "code": "missing_field"
    }
  ]
}
{% endresponse %}

All error objects have resource and field properties so that your client can tell what the problem is. There's also an error code to let you know what is wrong with the field. These are the possible validation error codes:

Error Name|Description
---|---
missing|This means a resource does not exist.
missing_field|This means a required field on a resource has not been set.
invalid|This means the formatting of a field is invalid. The documentation for that resource should be able to give you more specific information.
already_exists|This means another resource has the same value as this field. This can happen in resources that must have some unique key (such as Label names).

Resources may also send custom validation errors (where code is custom). Custom errors will always have a message field describing the error, and most errors will also include a documentation_url field pointing to some content that might help you resolve the error.

<!-- ### HTTP Redirects

API v1 uses HTTP redirection where appropriate. Clients should assume that any request may result in a redirection. Receiving an HTTP redirection is not an error and clients should follow that redirect. Redirect responses will have a `Location` header field which contains the URI of the resource to which the client should repeat the requests.

Status Code|Description
---|---
301	|Permanent redirection. The URI you used to make the request has been superseded by the one specified in the Location header field. This and all future requests to this resource should be directed to the new URI.
302, 307|Temporary redirection. The request should be repeated verbatim to the URI specified in the Location header field but clients should continue to use the original URI for future requests. -->

### HTTP Verbs

where possible, API v1 strives to use appropriate HTTP verbs for each action.

Verb|Description
---|---
GET	|Used for retrieving resources.
POST|	Used for creating resources.
PATCH|	Used for updating resources with partial JSON data. For instance, an Issue resource has title and body attributes. A PATCH request may accept one or more of the attributes to update the resource. PATCH is a relatively new and uncommon HTTP verb, so resource endpoints also accept POST requests.
PUT|	Used for replacing resources or collections. For PUT requests with no body attribute, be sure to set the Content-Length header to zero.
DELETE|	Used for deleting resources.

Some clients might have difficulty to set HTTP verbs, and the substituted approach would be that appended `_method=[Verb.]` to the query parameters.

`_method` should **not** be involved in any encryption process.

### Authentication

There are two ways to authenticate through PPJ API v1. Requests that failed on authentication would get response `404 Not Found`, instead of `403 Forbidden`, in some places.

#### parameters
name|type|description
---|---|---
Credential|string|PPJ AppID, get from PPJ website
Timestamp|Unix Timestamp| timestamp used by signature process
Signature|string|Authentication signature, see [here](./signature.md)

#### methods

1. Authentication Token (sent in a header)

   <pre class='command-line'>
   <span class='command'>curl -H 'X-PPJ-Credential: YOUR-APPID' \
        -H 'X-PPJ-Timestamp: XXXXXXXXXXX' \
        -H 'X-PPJ-Signature: AUTH-TOKEN' \
        https://api.ppj.io/</span>
   </pre>

2. Authentication Token (sent in parameters)

   <pre class='command-line'>
   <span class='command'>curl 'https://api.ppj.io/jobs/whatever?_credential=XXXX&_timestamp=XXXXXX&_signature=XXXXXX'</span>
   </pre>

   `_[key]` should __not__ be involved in any encryption process.

### Pagination

_wait to be filled._

### Credits

This API is inspired mostly by [Github.com](https://developers.github.com) and [Amazon.com](https://aws.amazon.com/api-gateway/).
