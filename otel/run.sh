#!/usr/bin/env bash
set -euo pipefail
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JAR="${JAR:-$APP_DIR/target/salary-0.1.0-RELEASE.jar}"
JAVA_AGENT="${JAVA_AGENT:-/opt/opentelemetry/opentelemetry-javaagent.jar}"
test -f "$JAR" || { echo "ERROR: JAR not found: $JAR" >&2; exit 1; }
test -f "$JAVA_AGENT" || { echo "ERROR: OTEL Java agent not found: $JAVA_AGENT" >&2; exit 1; }
set -a; source "$APP_DIR/otel/otel.env"; set +a
exec java -javaagent:"$JAVA_AGENT" ${JAVA_OPTS:-} -jar "$JAR"
