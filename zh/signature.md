## 签名算法

### 授权签名算法

name|description|
---|---
APPID|PPJ AppID & AppSecret，从开发者后台获取
APPSECRET|
TIMESTAMP|Unix timestamp, 签名时用的时间戳，应与授权参数里面的一致
HMAC|见 [Wiki](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code)
sha256|哈希函数，见 [Wiki](https://en.wikipedia.org/wiki/SHA-2)
_大多数语言已经集成了实现HMAC和sha256的函数_

1. sign_parameters

   除非在接口文档里特殊说明，所有的请求参数都__应该__参与到签名算法。

   将所有签名参数的键按照ASCII升序排列，取URL键值对格式(key=value)，用'&amp;'相连，构造签名参数字符串。

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

### 服务器验证请求算法

该签名仅用于服务器验证，使用场景见[这里](./notify_url.md#validation-request).

以下使用到的参数中，NONCE的值见验证请求，其他参数见[上一节](#授权签名算法).

1. sign_key:

   ```
   sign_key = HMAC(algorithm='sha256', data='APPSECRET', key='TIMESTAMP')
   ```
2. signature:

   ```
   signature = HMAC(algorithm='sha256', data='NONCE', key='sign_key')

   e.g.
   NONCE = 7bzaglsx2y1nmujw
   sign_key = 8f91cf9d54ccb163af07cc05210ecee355ce92c95c1dbd5558d0f5b3218fac1f

   signature = 988b7b1bdd05d10a0b21840561097f2dbbabeaf7e2bbe0dc960856a5fcdeb84e

   ```
