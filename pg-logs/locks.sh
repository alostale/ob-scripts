# locks per table
grep "while locking .*relation" pg.log | rev | cut -d " " -f1 | rev | sort | uniq -c | sort -rn

# time wiainting locks in minutes
echo "waiting $(echo "$(grep 'acquired' pg.log | sed 's/\(.*after \)\(.*\) ms/\2/' | paste -sd+ - | bc)/60000" | bc) minutes"


# time waiting locks per table in minutes
for i in $(grep "while locking .*relation" pg.log | rev | cut -d " " -f1 | rev | sort | uniq); do  
 t=$(grep 'acquired' pg.log -A1 | grep -B1 "in relation $i" | grep acquired | sed 's/\(.*after \)\(.*\) ms/\2/'| paste -sd+ - | bc)
 t=$(echo $t/60000|bc)
 echo $t $i 
done

# processes locking
 grep "Process holding the lock" pg.log | sed 's/.*Process holding the lock: \([0-9]*\).*/\1/' | sort | uniq -c | sort -rn