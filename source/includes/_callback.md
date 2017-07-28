# Callback || 回调

将PPT转化成H5通常需要1-3分钟，如果文件较大或较复杂，转换时间可能更长。当转化完成或出现异常时，PP匠服务器会主动发送一个通知请求到客户服务器，以告知客户下载转化后的H5文件或转换失败。

<aside class="notice">
如果你不想开发一个接口用于处理我们的回调请求，你也可以通过轮询「查询特定 Job」接口查询状态，并根据状态做出相应的处理。
</aside>

<aside class="warning">
轮询接口的间隔时间建议在10秒以上。
</aside>

## Config Notify URL || 配置回调地址

```http
Status: 200 OK
Content-Type: application/json
```

```json
{
  "nonce": "请求中的nonce值"
}
```

> 你可以使用以下命令测试你的回调地址：

```shell
curl -i https://your-server.com/hook -d 'type=verify&nonce=a-random-string'
```

请在[开发信息](https://ppj.io/profile/api)页面的「调用配置 - 回调地址」部分填写你的回调地址。我们会以`POST`请求的方式请求该地址，并带上以下参数：

参数 | 类型 | 说明
--------- | ------- | -----------
type | String | 固定为`verify`，表示请求类型为验证
nonce | String | 随机字符串

请以右侧的格式响应该请求。

## Notify || 通知请求

> 我们将发送类似下面的请求：

```shell
curl -i https://your-server.com/hook -d 'type=complete&token=kuSzcH5AwaDY'
```

> 如果你的回调地址成功收到我们的请求，请返回状态码`200`。

```http
Status: 200
```

当一个Job转换成功或者出错时，PP匠会主动发一个通知请求来告知客户。

### 参数表

参数 | 类型 | 说明
--------- | ------- | -----------
token | String | Job 的标识
type | String | Job 处理结果。成功时为`complete`，失败时为`error`
code | Integer | 处理失败时提供，表示出错的状态码。`1` 表示PP匠服务器内部出错导致无法转化, `2` 表示上传的PPT源文件有问题，导致无法转化

### 期待响应

如果你的回调地址成功收到我们的请求，请返回状态码`200`。

### 错误重试

一个通知请求需要在10秒内回复，如果超时或者返回的状态码非`200`，我们将认为该请求失败，并在间隔一定时间后重新发送请求。我们会以以下公式计算间隔时间（单位为秒），且最多尝试25次。

`(retry_count ** 4) + 15 + (rand(30) * (retry_count + 1))`
