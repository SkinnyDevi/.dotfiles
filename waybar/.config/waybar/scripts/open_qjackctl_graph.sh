if ! pgrep -x "qjackctl" >/dev/null; then
  qjackctl &
  sleep 2 # Wait for QjackCtl to start
fi
# Send D-Bus command to open Graph view
dbus-send --system / org.rncbc.qjackctl.graph
