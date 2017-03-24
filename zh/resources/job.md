## Job
---
我们用 Job 来指代一次PPT转H5请求

### Job 状态示意

![chartflow.png](../static/chartflow.png)

其中 Converting, Rendering, Disting 为PP匠内部标记的状态，客户无需感知。

#### 状态表
状态值|描述
---|---
converting, rendering, disting| 服务器转化状态
notifying|正在通知客户服务器（此时可通过 download 接口下载生成好的 H5 文件）
completed|转化完成
deleted|所有资源已被移除（此时无法再通过 download 接口下载生成后的 H5 文件）
halted|出错状态

## Job 相关接口
---

部分接口有一个 alias. 用来表示等价接口。

以获得 Job 状态为例，发送 GET 请求到 `/jobs/8v9iSKnj` 等价于发送 GET 请求到 `/job/status?token=8v9iSKnj`。

在计算授权签名的时候，`token = 8v9iSKnj` 在两种方法里面都作为加密参数，但前者对应的 path 为`/jobs/8v9iSKnj`，而后者对应的 path 为 `/job/status`。

### 创建一个Job

```
POST /jobs   (alias. /job/create)
Content-Type: 'multipart/form-data'
```

#### 参数
参数名|类型|必须包含？|描述
---|---|---|---|---
file_md5|string|是|源PPT文件的 md5 值
file_source|File|是|file binaries

**file_source 应该在计算授权验证签名时过滤掉，见[示例](../signature.md#客户发送创建一个-job-的示例)。**

#### 响应
{% response header='200 OK' %}
{
  'token': 'hhNy1Eq6Py2Kjpyt'
}
{% endresponse %}

Token 是 Job 的识别参数，客户端需要保存 Token。之后，关于 Job 的状态和下载等请求都会使用这个参数。

### 获得 Job 状态

```
GET /jobs/[:token]   (alias. /job/status?token='token')
```
#### 参数
参数名|类型|描述
---|---|---
token|string|Job 标识

#### 响应
{% response header='200 OK' %}
{
  'state': 'completed'
}
{% endresponse %}

对于 state 的取值，详细解释见[状态表](#状态表)。

### 下载 Job 转化完毕后的H5文件

```
GET /jobs/[:token]/download   (alias. /job/download?token='token')
```
#### 参数
同[获得 Job 状态](#获得-job-状态)。

#### 响应
{% response header='200 OK' %}
Content-Type: 'application/zip'
Content-Disposition: attachment; filename="TOKEN.zip"
Content-Transfer-Encoding: binary
{% endresponse %}

当响应为 200 时，客户端可以通过响应的 Content 取得二级制文件。

__错误响应__

当前 Job 处于无法被下载的状态
{% response header='400 Bad Request' %}
{
  "message": "Downloading is not available",
  "type": "NotAcceptableError"
}
{% endresponse %}


### 查询 Jobs

获得创建的所有 Jobs

```
GET /jobs   (alias. /job/list)

{
  'state': 'completed',
  'start_date': '2017-03-16T02:20:39+00:00'
}
```
#### 参数
参数名|类型|是否必须？|描述
---|---|---|---
state|string|可选|PPT状态，可填写的值见[状态表](#状态表)
start_date|DateTime|可选|查询起始时间
end_date|DateTime|可选|查询终止时间

#### 响应
{% response header='200 OK' %}
{
  "count": 1,
  "tokens": [
    'fZoYvkua34zqYny8'
  ]
}
{% endresponse %}
