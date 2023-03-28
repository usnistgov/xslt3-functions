@echo off
echo Calling (quietly) to make manifest.md for your file (resource) manifest

rem batch file for invoking maven to get a directory listing for a current directory

set HERE=%cd%
set HERE_URI=file:///%HERE:\=/%

set APPLICATION_DIR=%~dp0

call mvn --quiet -f %APPLICATION_DIR%pom.xml exec:java -Dexec.mainClass="com.xmlcalabash.drivers.Main" -Dexec.args="-omd=%HERE_URI%/manifest.md -ohtml=NUL %APPLICATION_DIR%/directory-manifest.xpl path=%HERE_URI%"

echo Check for file %HERE_URI%/manifest.md

