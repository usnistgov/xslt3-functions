@echo off
echo Calling (quietly) to make manifest.md for your file (resource) manifest

rem batch file for invoking maven to get a directory listing for a current directory

set HERE=%cd%
set HEREPATH=file:///%HERE:\=/%

set APPLICATION_DIR=%~dp0

call mvn --quiet -f %APPLICATION_DIR%pom.xml exec:java -Dexec.mainClass="com.xmlcalabash.drivers.Main" -Dexec.args="-omd=%HEREPATH%/manifest.md -odirlist=NUL -ohtml=NUL %APPLICATION_DIR%/directory-manifest.xpl path=%HEREPATH%"

echo Check for file %HEREPATH%/manifest.md

