# Quotas

## List || 查询可用额度

```shell
curl -i -H "X-PPJ-Credential: ppj_is_great" \
     'https://ppj.io/api/quotas'
```

> 以上命令将返回如下格式的数据：

```http
Status: 200 OK
Content-Type: application/json
```

```json
{
  "summary": {
    "permanents": 15,
    "permanents_left": 10
  }
}
```

`GET https://ppj.io/api/quotas`

### 响应

返回该账号下的额度汇总信息。

- `summary.permanents`：项目总额度；
- `summary.permanents_left`：项目剩余额度。

<aside class="notice">
如果以上两项值为`null`，则表示无限额度。
</aside>
