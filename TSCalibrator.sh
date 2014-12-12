#!/bin/bash

FULL_W=1920
FULL_H=1880
TS_W=1280
TS_H=800
TS_X_OFFSET=0
TS_Y_OFFSET=1080

bc_string="scale=6;
full_width = $FULL_W;
full_height = $FULL_H;
ts_x_offset = $TS_X_OFFSET;
ts_y_offset = $TS_Y_OFFSET;
ts_width = $TS_W;
ts_height = $TS_H;
print ts_width/full_width, \" \", 0, \" \", ts_x_offset/full_width, \" \", 0, \" \", ts_height/full_height, \" \", ts_y_offset/full_height, \" \", 0, \" \", 0, \" \", 1
"

Matrix_string=`echo $bc_string | bc`

xrandr --output VGA1 --below DP1
RET=`xinput | grep "PIXCIR"`
if [ -n "$RET" ]; then
    echo "PIXCIR"
    Prop_string="PIXCIR HID Touch Panel"
fi

RET=`xinput | grep "Nuvoton"`
if [ -n "$RET" ]; then
    echo "Nuvoton"
    Prop_string="Nuvoton HID Transfer"
fi

xinput set-prop "$Prop_string" --type=float "Coordinate Transformation Matrix" $Matrix_string
