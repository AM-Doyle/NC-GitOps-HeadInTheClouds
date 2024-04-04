# Alert Server

This server uses the AWS SDK to send an email via Simple Email Service. It is to be used in conjunction with the Cat Server but can work separately for testing.

To try this server locally use `npm install` and `npm start`.

If you do run this locally, be aware that a Grafana container in a cluster cannot reach this server as it is not in the same network.

## Endpoints

### GET /health

Health endpoint for monitoring

Example response

Status 200

```json
{
  "health": "OK"
}
```

### POST /api/alerts/v1

Sends a command to AWS SES and returns a 201 with no body.

Example Request from Grafana

The structure must match this but the only required properties are `alertname` and `pod` if you wish.

```json
[
  {
    "labels": {
      "__alert_rule_uid__": "fe5d9fa7-d824-453e-8ad0-142aa3ce6c42",
      "__name__": "hunger_level",
      "alert": "cat",
      "alertname": "cat is hungry",
      "container": "cat-server",
      "endpoint": "metrics-port",
      "grafana_folder": "hunger-alerts",
      "instance": "10.1.0.117:3000",
      "job": "cat-service",
      "namespace": "default",
      "pod": "cat-server-5776bcd9cb-x8br4",
      "service": "cat-service"
    },
    "annotations": {
      "__orgId__": "1",
      "__value_string__": "[ var='B' labels={__name__=hunger_level, container=cat-server, endpoint=metrics-port, instance=10.1.0.117:3000, job=cat-service, namespace=default, pod=cat-server-5776bcd9cb-x8br4, service=cat-service} value=100 ], [ var='C' labels={__name__=hunger_level, container=cat-server, endpoint=metrics-port, instance=10.1.0.117:3000, job=cat-service, namespace=default, pod=cat-server-5776bcd9cb-x8br4, service=cat-service} value=1 ]",
      "__values__": "{\"B\":100,\"C\":1}"
    },
    "startsAt": "2023-11-15T15:59:00Z",
    "endsAt": "0001-01-01T00:00:00Z",
    "generatorURL": "http://localhost:3000/alerting/grafana/fe5d9fa7-d824-453e-8ad0-142aa3ce6c42/view",
    "UpdatedAt": "2023-11-15T16:09:05.049066343Z",
    "Timeout": false
  }
]
```
