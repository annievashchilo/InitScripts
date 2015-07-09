DESC="Selenium Grid Server"
RUN_AS="selenium"
JAVA_BIN="/usr/bin/java"

 
SELENIUM_DIR="/Users/Anny/Projects/selenium_python"
JAR_NAME="selenium-server.jar"
JAR_FILE="$SELENIUM_DIR/$JAR_NAME"


while getopts p:c:H: option
do
    case "${option}" in
        p) PORT=${OPTARG};;
        c) COMMAND=${OPTARG};;
        H) HOST=${OPTARG};;
    esac
done


case $COMMAND in
    start)
        echo -n "Starting $DESC: "

        if java -jar $JAR_FILE -role hub -$PORT; then
            echo "0"
        else
            echo "1"
        fi
        ;;
    stop)
        echo -n "Stopping $DESC: "
        result=$(ps -ef | grep -v grep | grep "selenium-server.jar -role hub" | awk '{print $2}' | head -n1)
        
        echo "PID $result"
        
        if kill $result; then
            echo "Stopped $DESC $HOST:$PORT: 0"
        else 
            echo "Not stopped $DESC $HOST:$PORT: 1"
            exit 1
        fi
        ;;

    *)
        echo "Usage: -p NODE_PORT -H HUBURL -c COMMAND {start|stop}" >&2
        exit 1
        ;;
esac