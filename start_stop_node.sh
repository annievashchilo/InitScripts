#!/bin/bash

while getopts h:H:p:c: option
do
    case "${option}" in
        h) HUB=${OPTARG};;
        H) HUB_PORT=${OPTARG};;
        p) PORT=${OPTARG};;
        c) COMMAND=${OPTARG};;
    esac
done


DESC="Selenium Grid Node"
RUN_AS="selenium"
JAVA_BIN="/usr/bin/java"
HUBURL="http://${HUB}:${HUB_PORT}/grid/register"
 
SELENIUM_DIR="/Users/Anny/Projects/selenium_python"
JAR_NAME="selenium-server.jar"
JAR_FILE="$SELENIUM_DIR/$JAR_NAME"

show_status() 
{
	result=$(ps -ef | grep -v grep | grep "selenium-server.jar -role webdriver" | awk '{print $14}')
    
    for str in ${result}
    do
    	if [ $str ]; then
    		echo "Selenium Node is running on $str port"
    	else
    		echo "No launched Selenium Node"
		fi 
    done
       
}


case $COMMAND in
    start)
        echo -n "Starting $DESC: "
        if $HUB == null; then
        	echo "Usage: -p NODE_PORT -h HUB_IP -H HUB_PORT -c COMMAND {start|stop|status}" >&2
        	exit 1
        fi
        

        if $(terminal -e 'java -jar $JAR_FILE -role webdriver -port $PORT -hub ${HUBURL}'); then
            echo "0"
        else
            echo "1"
        fi
        ;;
    stop)
        echo -n "Stopping $DESC: "
        result=$(ps -ef | grep -v grep | grep "selenium-server.jar -role webdriver" | awk '{print $2}' | head -n1)
        
        echo "PID $result"
        
        for pid in ${result}
        do
        	if kill $pid; then
            	echo "Stopped $DESC $HOST:$PORT: 0"
            	show_status
        	else 
            	echo "Not stopped $DESC $HOST:$PORT: 1"
            	exit 1
        	fi
        done	
        
        ;;
    status)
		show_status
		;;
    *)
        echo "Usage: -p NODE_PORT -h HUB_IP -H HUB_PORT -c COMMAND {start|stop|status}" >&2
        exit 1
        ;;
esac
