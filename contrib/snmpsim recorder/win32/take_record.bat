@ECHO off
SET AGENT_ADDRESS=%1
SET AGENT_COMMUNITY=%2
SET DEVICE_NAME=%3

REM Common
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.1.1 --stop-oid=1.3.6.1.2.1.1.6 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.2.2.1 --stop-oid=1.3.6.1.2.1.2.2.2 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.4.20.1.2 --stop-oid=1.3.6.1.2.1.4.20.1.4 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.4.1.9.5.1.2 --stop-oid=1.3.6.1.4.1.9.5.1.3 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.4.1.9.5.1.4.1.1 --stop-oid=1.3.6.1.4.1.9.5.1.4.1.2 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.4.1.9.9.68.1.2.2.1 --stop-oid=1.3.6.1.4.1.9.9.68.1.2.2.2 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.10.7.2.1.19 --stop-oid=1.3.6.1.2.1.10.7.2.1.20 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.2 --stop-oid=1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.3 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.17.1 --stop-oid=1.3.6.1.2.1.17.3 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.31.1.1.1 --stop-oid=1.3.6.1.2.1.31.1.1.2 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.2.1.47.1.2.1.1.2 --stop-oid=1.3.6.1.2.1.47.1.2.1.1.3 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.

REM NetScreen
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.4.1.3224.8 --stop-oid=1.3.6.1.4.1.3224.10 --output-file=devices/%DEVICE_NAME%.rec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=161 --v2c --community=%AGENT_COMMUNITY% --start-oid=1.3.6.1.4.1.3224.15 --stop-oid=1.3.6.1.4.1.3224.16 --output-file=devices/%DEVICE_NAME%.rec

ECHO Done!