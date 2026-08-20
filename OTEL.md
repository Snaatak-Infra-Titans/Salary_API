# Salary API OpenTelemetry

This service uses the OpenTelemetry Java Agent for **traces, metrics and logs**.
The application keeps its existing Spring Actuator `/actuator/prometheus`
endpoint for Prometheus scraping.

## Pipeline

```text
Salary API
  ├─ traces ─┐
  ├─ metrics ─┼─ OTLP HTTP :4318 → OTEL Collector
  └─ logs ────┘                    ├─ Tempo
                                   ├─ Prometheus
                                   └─ Loki
```

## Requirements

Java 17 and:

```text
/opt/opentelemetry/opentelemetry-javaagent.jar
```

## Build

```bash
cd /home/ubuntu/Salary_API
./mvnw clean package -DskipTests
```

## Install systemd service

```bash
sudo cp deploy/salary-api.service /etc/systemd/system/salary-api.service
sudo systemctl daemon-reload
sudo systemctl enable salary-api.service
sudo systemctl restart salary-api.service
sudo systemctl status salary-api.service --no-pager -l
```

## Validate

```bash
curl -i http://localhost:8082/actuator/health
curl -s http://localhost:8082/actuator/prometheus | head -50
```

Generate traffic using a real Salary API route, for example:

```bash
curl -s http://localhost:8082/api/v1/salary/search/all >/dev/null
```

Then:

```bash
sudo journalctl -u salary-api.service --since "2 minutes ago" --no-pager -o cat
```

Check for exporter failures:

```bash
sudo journalctl -u salary-api.service --since "2 minutes ago" --no-pager -o cat  | grep -Ei 'failed|error|export|otel'
```

The OTLP base endpoint is intentionally:

```text
http://otms.monitoring.internal:4318
```

The Java agent derives `/v1/traces`, `/v1/metrics`, and `/v1/logs`.
Do not append a signal path to `OTEL_EXPORTER_OTLP_ENDPOINT`.
