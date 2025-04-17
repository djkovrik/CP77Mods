"%~dp0\..\..\..\red-cli.exe" bundle
echo f | xcopy /f /y Release\r6\scripts\Sleeves\Sleeves.Global.reds Release\r6\scripts\sleeves.reds
rmdir /s /q Release\r6\scripts\Sleeves
pause
