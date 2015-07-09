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

                                                                                                                                                                                                                  
DESC="Selenium Grid Server"
RUN_AS="selenium"
JAVA_BIN="/usr/bin/java"
HUBURL="http://${HUB}:${HUB_PORT}/grid/register"

SELENIUM_DIR="~/Projects/selenium_python/"
PID_FILE="$SELENIUM_DIR/selenium-node.pid"
JAR_FILE="$SELENIUM_DIR/selenium-server.jar"
LOG_DIR="/var/log/selenium"
LOG_FILE="${LOG_DIR}/selenium-grid.log"
 
USER="selenium"
GROUP="selenium"
 
MAX_MEMORY="-Xmx256m"
STACK_SIZE="-Xss8m"

#java -jar selenium-server-standalone-2.37.0.jar -role webdriver -hub http://10.153.30.102:4412/grid/register -port 4412
 
DAEMON_OPTS=" -client $MAX_MEMORY $STACK_SIZE -jar $JAR_FILE -role webdriver -hub ${HUBURL} -log $LOG_FILE -port ${PORT}" 
 
DISPLAY_PORT=501

 
NAME="Selenium Node"
 
if [ $COMMAND != status ]; then
    if [ ! -d ${LOG_DIR} ]; then
        mkdir --mode 750 --parents ${LOG_DIR}
        #chown ${USER}:${GROUP} ${LOG_DIR}
    fi  
fi
 
. /lib/lsb/init-functions
 
case $COMMAND in
    start)
        export DISPLAY=:${DISPLAY_PORT}.0
        log_daemon_msg "Starting ${DESC}: " $NAME
        echo "Starting ${DESC}: " $NAME
        if start-stop-daemon -c $RUN_AS --start --background --pidfile $PID_FILE --make-pidfile --exec $JAVA_BIN -- $DAEMON_OPTS ; then
            log_end_msg 0
        else
            log_end_msg 1
        fi
        ;;
 
    stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --pidfile $XVFB_PID_FILE
        start-stop-daemon --stop --pidfile $PID_FILE
        echo "$NAME."
        ;;
 
    restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --pidfile $PID_FILE
        sleep 1
        start-stop-daemon -c $RUN_AS --start --background --pidfile $PID_FILE  --make-pidfile --exec $JAVA_BIN -- $DAEMON_OPTS
        echo "$NAME."
        ;;
 
    status)
        status_of_proc -p "$XVFB_PID_FILE" "$DAEMON" "Xvfb" && status_of_proc -p "$PID_FILE" "$DAEMON" "Selenium node" && exit 0 || exit $?
        ;;
 
    *)
        N=/etc/init.d/$NAME
        echo "Usage: $N -h HUB -H HUB_PORT -p NODE_PORT -c COMMAND {start|stop|restart|force-reload|status}" >&2
        exit 1
        ;;
esac
