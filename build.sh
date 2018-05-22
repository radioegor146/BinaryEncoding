#!/usr/bin/env bash

set -e

if [ $TRAVIS_OS_NAME = "osx" ]; then
  ulimit -n 1024
  dotnet restore --disable-parallel --runtime osx-x64
else
  dotnet restore --runtime ubuntu-x64
fi

export FrameworkPathOverride=$(dirname $(which mono))/../lib/mono/4.5/

dotnet test ./test/BinaryEncoding.Tests/BinaryEncoding.Tests.csproj -c Release -f netcoreapp1.1
dotnet build ./test/BinaryEncoding.Tests/BinaryEncoding.Tests.csproj -c Release -f net452

mono $HOME/.nuget/packages/xunit.runner.console/*/tools/net452/xunit.console.exe ./test/BinaryEncoding.Tests/bin/Release/net452/BinaryEncoding.Tests.dll
