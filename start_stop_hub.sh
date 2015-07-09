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


show_status() {
    result=$(ps -ef | grep -v grep | grep "selenium-server.jar -role hub" | awk '{print $14}')
    for str in ${result}
    do
        if [ $str ]; then
            echo "Selenium Hub is running on $str port"
        else
            echo "No launched Selenium Node"
        fi 
    done
}

case $COMMAND in
    start)
        echo -n "Starting $DESC: "

        if $(terminal -e 'java -jar $JAR_FILE -role hub -port $PORT'); then
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
            show_status
        else 
            echo "Not stopped $DESC $HOST:$PORT: 1"
            exit 1
        fi
        ;;
    status)
        show_status    
        ;;

    *)
        echo "Usage: -p HUB_PORT -H HUB_IP -c COMMAND {start|stop|status}" >&2
        exit 1
        ;;
esac
