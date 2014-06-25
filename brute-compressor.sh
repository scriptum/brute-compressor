#!/bin/sh

if [ $# -lt 1 ]
then
	echo "Usage: $0 <file>"
	exit -1
fi

FILE=$1
BESTCMD="You shouldn't compress that"
BESTSIZE=$(wc -c < "$FILE")

for C in gzip bzip2
do
	for i in $(seq 9)
	do
		CMD="$C -$i"
		S=$($CMD < "$FILE" | wc -c)
		if [ "$(echo $S '<' $BESTSIZE | bc -l)" -eq 1 ]
		then
			BESTCMD="$CMD"
			BESTSIZE=$S
			echo "$BESTCMD ($BESTSIZE)"
		fi
	done
done

for C in xz lzma
do
	for LC in $(seq 0 4)
	do
	for LP in $(seq 0 4)
	do
	if [ "$(echo $LC + $LP '<=' 4 | bc -l)" -eq 1 ]
	then
	for PB in $(seq 0 4)
	do
	for MF in hc3 hc4 bt4
	do
	# for N in $(seq 1 8 256)
	# do
		if [ $C = "xz" ]
		then F=lzma2
		else F=lzma1
		fi
		CMD="$C -9 --$F=lc=$LC,lp=$LP,pb=$PB,mf=$MF"
		# echo $CMD
		S=$($CMD < "$FILE" | wc -c)
		if [ "$(echo $S '<' $BESTSIZE | bc -l)" -eq 1 ]
		then
			BESTCMD="$CMD"
			BESTSIZE=$S
			echo "$BESTCMD ($BESTSIZE)"
		fi
	# done
	done
	done
	fi
	done
	done
done
