@ECHO off
SET AGENT_ADDRESS=%1
SET AGENT_COMMUNITY=%2
SET DEVICE_NAME=%3

REM Common
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1 --stop-oid=1.3.6.2 --output-file=devices/%DEVICE_NAME%_full.snmprec

ECHO Done!