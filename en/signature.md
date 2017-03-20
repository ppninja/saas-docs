## Signature

### Authentication Signature

name|description|
---|---
APPID|PPJ AppID & AppSecret get from PPJ website
APPSECRET|see above
TIMESTAMP|Unix timestamp, should be constant during each process
HMAC|see [Wiki](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code)
sha256|hash function, see [Wiki](https://en.wikipedia.org/wiki/SHA-2)
_most languages have built-in ways to calculate HMAC with sha256_

1. sign_parameters

   For requests that need to be authenticated, all of their parameters need to be included, except those explicitly marked as exclusive.

   Sort parameters by keys in ASCII ascending order, connecting each key/value pair with '=' in URL format, and joint with '&amp;'.

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

   Join the request' method, path with result from step 1

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

### Validation Signature

This signature is used particularly on server validation. see [here](./notify_url.md#validation-request).

NONCE is the value in the request, and other interpretations see [previous section](#authentication-signature).

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
