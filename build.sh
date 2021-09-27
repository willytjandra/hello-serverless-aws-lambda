#!/bin/bash

set -euo pipefail

exec 3>&1
function say() {
  printf "%b\n" "[build] $1" >&3
}

say "Restoring nuget packages"
dotnet restore

say "Build solution"
dotnet build -c Release --no-restore

say "Running tests"
dotnet test -c Release --no-build

dotnet tool install -g Amazon.Lambda.Tools

say "Packaging lambda"
dotnet lambda package \
  --configuration Release \
  --framework netcoreapp3.1 \
  --project-location . \
  --output-package bin/Release/netcoreapp3.1/hello.zip


