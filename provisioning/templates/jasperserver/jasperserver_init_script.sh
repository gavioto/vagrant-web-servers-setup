#!/bin/sh
### BEGIN INIT INFO
# Provides:          jasperserver
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start JasperServer at boot time
# Description:       Enable service provided by JasperServer.
### END INIT INFO

JASPER_HOME="/opt/jasperserver"

case "$1" in
  start)
    if [ -f $JASPER_HOME/ctlscript.sh ]; then
      echo "Starting JasperServer"
      $JASPER_HOME/ctlscript.sh start
    fi
    ;;
  stop)
    if [ -f $JASPER_HOME/ctlscript.sh ]; then
      echo "Stopping JasperServer"
      $JASPER_HOME/ctlscript.sh stop
    fi
    ;;
  restart)
    if [ -f $JASPER_HOME/ctlscript.sh ]; then
      echo "Restarting JasperServer"
      $JASPER_HOME/ctlscript.sh restart
    fi
    ;;
  status)
    if [ -f $JASPER_HOME/ctlscript.sh ]; then
      $JASPER_HOME/ctlscript.sh status
    fi
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac