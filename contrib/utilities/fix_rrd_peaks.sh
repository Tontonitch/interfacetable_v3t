#!/bin/bash
#set -x

## 19.06.2012 Timo Soeder - ARZ Emmendingen
##
## Beseitigung von Spikes in RRDs (z. B. Counter-Ueberlauf, etc).
## Dumpt die If*.rrds, ersetzt die Spikes mit "normaleren" Werten,
## und restored sie dann wieder.
##
## Usage: ./fix-rrds.sh /usr/local/nagios/share/perfdata/*


for i in `ls -d $1`; do

    cd $i
    echo "######################## Verzeichnis $i ##########################"
        
    #for x in `ls  Gig*.rrd If_*.rrd TenGig*.rrd FastE*.rrd 2>/dev/null`; do
    for x in `ls  If_*.rrd 2>/dev/null`; do
    
        echo "- Backup $x to $x.bak -"
        cp -p "$x" "$x".bak
        
        echo "- Dump - "
        rrdtool dump "$x" > ${x%.rrd}.xmldump
        
        echo "- Count -"
        #example: <row><v>2.7379003102e+09</v></row>
        anz1x=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+1[1-8]' ${x%.rrd}.xmldump | wc -l`
        anz10=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+10' ${x%.rrd}.xmldump | wc -l`
        anz9=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+09' ${x%.rrd}.xmldump | wc -l`
        anz8=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+08' ${x%.rrd}.xmldump | wc -l`
        anz7=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+07' ${x%.rrd}.xmldump | wc -l`
        anz6=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+06' ${x%.rrd}.xmldump | wc -l`
        anz5=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+05' ${x%.rrd}.xmldump | wc -l`
        anz4=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+04' ${x%.rrd}.xmldump | wc -l`
        anz3=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+03' ${x%.rrd}.xmldump | wc -l`
        anz2=`egrep '\<v\>.[0-9]\.[0-9]{10}e\+02' ${x%.rrd}.xmldump | wc -l`
        anzmin=`egrep '\<v\>.[0-9]\.[0-9]{10}e\-0[1-7]' ${x%.rrd}.xmldump | wc -l`
        
        echo "$anz1x 1xer"
        echo "$anz10 10er"
        echo "$anz9 9er"
        echo "$anz8 8er"
        echo "$anz7 7er"
        echo "$anz6 6er"
        echo "$anz5 5er"
        echo "$anz4 4er"
        echo "$anz3 3er"
        echo "$anz2 2er"
        echo "$anzmin e-"
        
        read -s -n 1 -p "Press any key to continue..."
        
        echo "- Sed e- -"
        if [ $anzmin -le 50 ] && [ $anzmin -gt 0 ]
            sed -e 's/v\>.[0-9]\.[0-9]\{10\}e-0[1-7]/v>NaN/g' -i ${x%.rrd}.xmldump
            echo "e-"
        fi
        
        echo "- Sed e+ -"
        if [ $anz1x -le 50 ] && [ $anz1x -gt 0 ]
            then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+1[1-8]/v>NaN/g' -i ${x%.rrd}.xmldump
            echo "1xer"
        fi
        if [ $anz10 -le 50 ] && [ $anz10 -gt 0 ]
            then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+10/v>NaN/g' -i ${x%.rrd}.xmldump
            echo "10er"
        fi
        if [ $anz9 -le 50 ] && [ $anz9 -gt 0 ]
            then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+09/v>NaN/g' -i ${x%.rrd}.xmldump
            echo "9er"
        fi
        #if [ $anz8 -le 50 ] && [ $anz8 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+08/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "8er"
        #fi
        #if [ $anz7 -le 50 ] && [ $anz7 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+07/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "7er"
        #fi
        #if [ $anz6 -le 50 ] && [ $anz6 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+06/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "6er"
        #fi
        #if [ $anz5 -le 50 ] && [ $anz5 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+05/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "5er"
        #fi
        #if [ $anz4 -le 50 ] && [ $anz4 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+04/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "4er"
        #fi
        #if [ $anz3 -le 50 ] && [ $anz3 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+03/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "3er"
        #fi
        #if [ $anz2 -le 50 ] && [ $anz2 -gt 0 ]
        #    then sed -e 's/v\>.[0-9]\.[0-9]\{10\}e+02/v>NaN/g' -i ${x%.rrd}.xmldump
        #    echo "2er"
        #fi
        
        echo "- Restore ${x%.rrd}.xmldump -"
        rrdtool restore ${x%.rrd}.xmldump "$x" -f
        rm ${x%.rrd}.xmldump
    
    done
    #rm If*.xmldump
    #rm If*.bak
    cd ..

done