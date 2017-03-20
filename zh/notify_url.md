## 回调地址

将PPT转化成H5是一个长时间的异步过程，意味着当转化结束时，PP匠服务器会主动发送一个通知请求到客户服务器，来通知客户下载生成好的H5文件。因此客户需要在后台配置回调地址。

### 配置回调地址

![notify_url_setting_pane](static/notify_url_setting_pane.png)

保存后需要点击’验证‘按钮来发送验证请求；只有验证通过的服务器才会在之后收到回调请求。

### 验证请求
{% command %}curl https://your_server_notify_address?type=verify&amp;timestamp=XXXX&nonce=XXXXX&signature=XXXXX
{% endcommand %}

#### 参数

参数名|类型|值|描述
---|---|---|---
type|string|verify|该请求类型，verify表示验证
timestamp|Unix Timestamp||签名用时间戳
nonce|string||随机字符串
signature|string||验证签名，算法见[这里](./signature.md#服务器验证请求算法)

#### 期待响应
{% response header='200 OK' %}
Content-Type: 'application/json'

{
  'nonce': 'XXXXXXX'
}
{% endresponse %}

客户服务器返回一个json，包含请求发送的Nonce，则PP匠这边就会标记该服务器验证通过。

PP匠同时提供一个签名Signature用来辅助客户验证发送服务器是否合法，但这__不是必要__的。


### 通知请求

当一个Job完成，或者出错时，PP匠会主动发一个通知请求来告知客户。

{% command %} curl https://your_server_notify_address?type=XXX&token=XXX&code=XXXX
{% endcommand %}

#### 参数

参数名|类型|值|描述
---|---|---|---
type|string|['complete', 'error']|分别表示token对应的Job完成或者失败
token|string||Job标识码，见 [创建一个Job](./resources/job.md#创建一个job).
code|integer|[1, 2]|出错状态码, 1 表示PP匠服务器内部出错导致无法转化 2 表示上传的PPT源文件有问题，导致无法转化

#### 期待响应
{% response header='200 OK' %}
{}
{% endresponse %}

一个通知请求需要在10s内回复，否则PP匠会认为通知发送失败，会在几秒后重复推送，直到成功收到200返回为止。

_请先响应通知，再处理您的业务逻辑_
