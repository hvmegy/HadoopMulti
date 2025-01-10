@echo off

REM The default node number is 3
set N=%1
if "%N%"=="" set N=3

rem Call the resize-number-slave.bat with the number of slaves as an argument
call resize-number-slaves.bat %N%

rem create hadoop network
docker network create --driver=bridge hadoop-network >nul 2>&1

REM Start Hadoop master container
echo start minhquang-master container...
docker rm -f minhquang-master >nul 2>&1
docker run -itd ^
    --net=hadoop-network ^
    --name minhquang-master ^
    --hostname minhquang-master ^
    docutee/hadoop-master >nul 2>&1

REM Start Hadoop slave containers
set /a i=1
:loop
if %i% lss %N% (
    echo start minhquang-slave%i% container...
    docker rm -f minhquang-slave%i% >nul 2>&1
    docker run -itd ^
        --net=hadoop-network ^
        --name minhquang-slave%i% ^
        --hostname minhquang-slave%i% ^
        docutee/hadoop-slave >nul 2>&1
    set /a i=%i% + 1
    goto loop
)

REM Get into the Hadoop master container
docker start -i minhquang-master

