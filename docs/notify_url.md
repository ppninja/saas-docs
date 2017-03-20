## Notify Url

Converting PPTs into Html format is an asynchronous job, which might take up to several minutes. When PPJ finish a convert job, it would initiatively send a request to your server, to inform you that outputs are ready to be downloaded. Hence, you need set up a notify url in the developer center.

### Config notify url

![notify_url_setting_pane](static/notify_url_setting_pane.png)

Using validation button to send a validation request to your server. Only validated address would receive the notify request in the future.

### Validation Request

<pre class='command-line'>
<span class='command'>curl https://your_server_notify_address?type=verify&amp;timestamp=XXXX&nonce=XXXXX&signature=XXXXX</span>
</pre>

#### parameters

name|type|value|description
---|---|---|---
type|string|verify|type of notification, other values are explained in [notify](#notify-request)
timestamp|Unix Timestamp||signature used timestamp
nonce|string||a random generated token
signature|string||a validation signature, see [here](./signature.md#validation-signature)

#### expected response
{% response header='200 OK' %}
{
  'nonce': 'XXXXXXX'
}
{% endresponse %}

PPJ server would mark the notify url as valid, if the server got a successful response with the same Nonce value in the request. PPJ provides a signature for clients to validate the legality of PPJ servers, however, it would be __not__ required.

### Notify Request

when a job is finished, or halted with errors, we would initiatively send a notify request to your server.

<pre class='command-line'>
<span class='command'>curl https://your_server_notify_address?type=XXX&token=XXX&code=XXXX</span>
</pre>

#### parameters

name|type|value|description
---|---|---|---
type|string|['complete', 'error']|stands for whether a project is complete or halted by errors
token|string||a token to a job, see [create]()
code|integer||error code, 1 stands for server internal error, 2 stands for source file error

#### expected response
{% response header='200 OK' %}
{}
{% endresponse %}

if PPJ server cannot read a 200 response within 10 seconds, it would retry the notification in several seconds.

_Please respond immediately after you receive the notification._
