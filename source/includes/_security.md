# Security || 安全措施

## Https Only || 使用https

请使用`https`请求我们的API，尝试使用`http`将得到`400`错误。此外，我们建议您在客户端验证CA证书有效性。

## IP Whitelist || 设置IP白名单

```shell
curl -i -H "X-PPJ-Credential: your_access_key" https://ppj.io/api/jobs
```

```http
Status: 403 Forbidden
Content-Type: application/json
```

```json
{
  "message": "客户端IP不在白名单中，请在后台设置。",
  "type": "PermissionError"
}
```

如果你希望只有特定机器发起的请求才被接受，则可以在[开发信息](https://ppj.io/profile/api)页面的「调用配置 - IP 白名单」部分设置。我们支持以下格式：

**允许指定IP**

`220.181.57.217`

**允许指定IP段**

`220.181.57.0/24`

**允许多个IP或IP段**

`220.181.57.217;220.181.57.0/24`

使用 IP 白名单范围外的 IP 发送请求将返回`403 Forbidden`错误。

<!-- ## Signature || 验证请求参数签名

如果你希望进一步加强请求的安全性，则可以启用「验证请求参数签名」。 -->
