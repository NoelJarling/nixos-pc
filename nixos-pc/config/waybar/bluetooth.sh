#!/bin/bash
if bluetoothctl info CC:08:FA:CB:9D:0A | grep "Connected: yes"
then
    bluetoothctl disconnect CC:08:FA:CB:9D:0A
else
    bluetoothctl connect CC:08:FA:CB:9D:0A
fi