#! /bin/bash

# Set d-bus machine-id
if [ ! -s /etc/machine-id ]; then
  dbus-uuidgen > /etc/machine-id
fi
# Properly start DBus
export DISPLAY=:0 # workaround dbus asks for DISPLAY to be set
#export GTK_DEBUG=all
#export GDK_DEBUG=all  
echo "eclipse:x:$(id -u):0:root:/root:/bin/bash" >> /etc/passwd
mkdir -p /var/run/dbus
dbus-daemon --system --fork &
#export G_MESSAGES_DEBUG=all
export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --fork --print-address)

broadwayd $BROADWAY_DISPLAY -p $BROADWAY_PORT &

cd ~
echo '*** Please connect to http://'`grep $HOSTNAME /etc/hosts | awk '{print $1}'`':'`echo $BROADWAY_PORT`' using your web browser ***'

./eclipse/eclipse
sleep 20 #instead of sleep, we should wait for some event implying Eclipse IDE is ready to listen
gdbus call --session --dest org.eclipse.swt --object-path /org/eclipse/swt --method org.eclipse.swt.FileOpen "['/projects']"

# This allows Eclipse IDE to restart without stopping the container
tail -f /dev/null

# Tools to debug the container
#/bin/bash
#gtk3-demo
