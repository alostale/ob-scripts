# we're interested in events from 9:00 to 10:40
sed -i -e 1,$(grep -n -m 1 "^2017-11-13 09:00" pg.log | cut -f1 -d ":")d pg.log
sed -i -e $(grep -n -m 1 "^2017-11-13 10:40" pg.log | cut -f1 -d ":"),$(wc -l pg.log | cut -f 1 -d " ")d pg.log

# remove connections/disconnections
sed -i "/.*LOG:  connection authorized:/d" pg.log
sed -i "/.*LOG:  connection received/d" pg.log
sed -i "/.*LOG:  disconnection: session time:/d" pg.log

# make lines shorter removing common stuff
sed -i 's/user=tad,db=openbravo,app=\[unknown\],client=10.130.3.94 //' pg.log