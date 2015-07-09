DESC="Selenium Grid Server"
RUN_AS="selenium"
JAVA_BIN="/usr/bin/java"
 
SELENIUM_DIR="~/Projects/selenium_python/"
JAR_FILE="$SELENIUM_DIR/selenium-server.jar"

while getopts p:c: option
do
    case "${option}" in
        p) PORT=${OPTARG};;
        c) COMMAND=${OPTARG};;
    esac
done


case $COMMAND in
    start)
        echo -n "Starting $DESC: "

        if java -jar $JAR_FILE -role hub - $PORT; then
            echo "0"
        else
            echo "1"
        fi
        ;;
    *)
        echo "Usage: -h HUB -H HUB_PORT -p NODE_PORT -c COMMAND {start|stop|restart|force-reload|status}" >&2
        exit 1
        ;;
esac