## Job

a job is a convert process of PPT to HTML.

### Create a Job

```
POST /jobs   (alias. /job/create)
```

#### parameters
name|type|required?|description
---|---|---|---|---
file_md5|string|T|md5 hash of uploaded file
file_source|File|T|file binaries

**file_source should be exclusive within authentication signature parameters. see [here]().**

Post with Content-Type: multipart/form-data.

#### response
{% response header='200 OK' %}
{
  'token': 'hhNy1Eq6Py2Kjpyt'
}
{% endresponse %}


Token is the reference to a job. Other requests such as checking converting status or downloading outputs would require it.

### Get a Job Status

```
GET /job/[:token]   (alias. /job/status?token='token')
```
#### parameters
name|type|description
---|---|---
token|string|a token to a job

#### response
{% response header='200 OK' %}
{
  'state': 'completed'
}
{% endresponse %}

For state interpretation, see [here](#job-status).

### Download a Job outcome

```
GET /job/[:token]/download   (alias. /job/download?token='token')
```
#### parameters
Same as [Get a Job Status](#get-a-job-status).

#### response
{% response header='200 OK' %}
Content-Type: 'application/zip'
Content-Disposition: attachment; filename="token.zip"
Content-Transfer-Encoding: binary
{% endresponse %}

If the status is 200, you could read binaries from response.body directly.

__failure__
<pre class='response'>
<span class='headers'>Status: 404</span>
</pre>

### List Jobs

return a list of your create jobs.

```
GET /jobs   (alias. /job/list)

{
  'status': 'completed',
  'start_date': '2017-03-16T02:20:39+00:00'
}
```
#### parameters
name|type|required?|description
---|---|---|---
status|string|False|state value, see possible [states](#job-status)
start_date|Timestamp|False|jobs create after this time
end_date|Timestamp|False|jobs create before this time

#### response
{% response header='200 OK' %}
{
  "count": 1,
  "tokens": [
    'fZoYvkua34zqYny8'
  ]
}
{% endresponse %}

### Job Status
state|description
---|---
converting, rendering, disting| on converting process
notifying|send notify request to users' server (download is available)
completed|finished (download is available)
deleted|all resources and outputs files are wiped in PPJ servers
