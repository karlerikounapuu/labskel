#!/bin/bash
apt-get install ruby hping3 -y &&

DIR="/root/scripts"
SYSDDIR="/usr/local/lib/systemd/system"
CHECKS=$(ls $DIR/checks)
if [ ! -d $SYSDDIR ]; then
	mkdir -p $SYSDDIR
fi

export RESULTS="$DIR/results"
if [ ! -d $RESULTS ]; then
        mkdir -p $RESULTS
fi

chmod +x -R $DIR/checks/

for CHK in $CHECKS ; do

cat > $SYSDDIR/$CHK.service <<EOF
[Unit]
After=network.target

[Service]
WorkingDirectory=$DIR/checks/
ExecStart=$DIR/checks/$CHK
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable $CHK
systemctl start $CHK

done
