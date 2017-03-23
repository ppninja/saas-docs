## 签名算法

### 参数表
参数名|描述
---|---
APPID，APPSECRET|PPJ AppID & AppSecret，从开发者后台获取
TIMESTAMP|Unix Timestamp，签名时用的时间戳，应与授权参数里面的一致
HMAC|见 [Wiki](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code)
sha256|哈希函数，见 [Wiki](https://en.wikipedia.org/wiki/SHA-2)
_大多数语言已经集成了实现 HMAC 和 sha256 的函数_

### 签名步骤

1. sign_parameters

   除非在接口文档里特殊说明，所有的请求参数都应该参与到签名算法。但 '\_' 开头的参数，如 '\_method'等，是保留参数，不参与签名步骤。

   将所有签名参数的键按照 ASCII 升序排列，取 URL 键值对格式（key=value），用 '&amp;' 相连，构造签名参数字符串。

   若请求不含参数，取空字符串。 `sign_parameters=""`

   ```
   e.g. parameters:
   {
     'start_date': '2017-03-16T02:20:39+00:00',
     'end_date': '2017-03-17T02:20:39+00:00',
     'status': 'completed'
   }
   ```
   ```
   result:
   end_date=2017-03-17T02:20:39+00:00&start_date=2017-03-16T02:20:39+00:00&status=completed
   ```  

2. sign_text

   按照以下方式连接http_method（即 GET, POST, etc.），请求路径，签名参数字符串

   ```
   sign_text = http_method + "\n" + path + "\n" + sign_parameters

   e.g. request:

   GET /jobs/list
   {
     'status': 'completed'
   }

   sign_text:

   GET
   /jobs/list
   status=completed

   ```

3. sign_key

   ```
   sign_key = HMAC(algorithm='sha256', data='APPSECRET', key='TIMESTAMP')

   e.g.
   TIMESTAMP = 1489820220
   APPSECRET = kKdBnfSJNnBjex9gczp6P9g2

   sign_key = 8f91cf9d54ccb163af07cc05210ecee355ce92c95c1dbd5558d0f5b3218fac1f
   ```

4. signature

   ```
   signature = HMAC(algorithm='sha256', data='sign_text', key='sign_key')

   e.g.
   for sign_text and sign_key from step 2 and 3

   signature = ecebba8f5ca8965833c05797c1c4cff8f48c6346594bad5f2d86bcdef33a7495
   ```

## 示例
```
假设有客户
APPID：shEgGCzL2QQi
APPSECRET: kKdBnfSJNnBjex9gczp6P9g2
配置的notify url: http://ppjclient.io/notify?agent=06875f8b
```
### 客户发送创建一个 Job 的示例
```
A file in current directory named 'test.pptx' has MD5 value: be92023d515907f5faaac32c3605d7ec.
current Timestamp: 1490089532

sign_parameters = 'file_md5=be92023d515907f5faaac32c3605d7ec'
sign_text = "POST\n/jobs\nfile_md5=be92023d515907f5faaac32c3605d7ec"
sign_key = "ee17afa6d69f1221c07b1cd3edba30e3ae95331f663d04a606a3d53a5588bbb4"
signature = "562ef9fee364f995dc9e0e5b1d57a855afd4e4bfed4fa414d4937dd1c7c5547f"
```

{%command%}
curl -H "Accept: application/vnd.ppj.v1+json" \
     -H "X-PPJ-Credential: shEgGCzL2QQi" \
     -H "X-PPJ-Timestamp: 1490089532" \
     -H "X-PPJ-Signature: 562ef9fee364f995dc9e0e5b1d57a855afd4e4bfed4fa414d4937dd1c7c5547f" \
     -F "file_md5=be92023d515907f5faaac32c3605d7ec" \
     -F "file_source=@test.pptx" \
     http://ppj.io/jobs
{%endcommand%}

```
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"token":"8v9iSKnj"}
```

### PP 匠发送一个通知请求示例
```
token: '8v9iSKnj'
type: 'completed'
code: '0'
current Timestamp: 1490255398

sign_parameters = 'agent=06875f8b&code=0&token=8v9iSKnj&type=completed'
sign_text = "GET\n/notify\nagent=06875f8b&code=0&token=8v9iSKnj&type=completed"
sign_key = "e2eef1820e50b7ad16b208ff00b6b7cf7bb679e3de3d377fcfaf1e898e746dc6"
signature = '9b566f493c25afa7b57b6e2289f2382c32ab2393bdf0b0367ba77bb53dce36db'
```

{% command %}
curl -H "X-PPJ-Timestamp: 1490255398" \
     -H "X-PPJ-Signature: 9b566f493c25afa7b57b6e2289f2382c32ab2393bdf0b0367ba77bb53dce36db" \
     http://ppjclient.io/notify?agent=06875f8b&token=8v9iSKnj&type=completed&code=0
{% endcommand %}

```
HTTP/1.1 200 OK
```
