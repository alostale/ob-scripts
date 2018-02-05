#! /usr/bin/python3
import sys
import re
from datetime import datetime

MIN_DURATION=60000
timestamp_pattern = re.compile('^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}) \w{3} (\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}) \w{3}\s+(\d+\s+\d+/?\d+)')
ms_pattern = re.compile(' (\d*).?\d* ms ')

all_trx = {}

def read_log():
	for line in sys.stdin:
		if has_timestamp_and_trx(line):
			add_trx_and_time(line)

def has_timestamp_and_trx(l):
	return re.search(timestamp_pattern, l)

def add_trx_and_time(l):
	m = re.search(timestamp_pattern, l)
	trx_id = m.group(5)
	
	if trx_id == '0' or trx_id.endswith('/0'): return

	t = int(datetime.strptime(m.group(1)+ ' '+m.group(2), '%Y-%m-%d %H:%M:%S').timestamp()*1000)
	if trx_id in all_trx:
		cur_trx = all_trx[trx_id]
		cur_trx['last_seen'] = t
	else:
		d = re.search(ms_pattern,l)
		if d:
			duration = int(d.group(1))
			fs = int(t-duration)
		else:
			fs=t
		cur_trx = {'first_seen': fs, 'last_seen': t}
		all_trx[trx_id]=cur_trx
	
def print_trx():
	for trx_id in  all_trx:
		curr = all_trx[trx_id]
		duration = int(curr['last_seen']-curr['first_seen'])
		curr['duration'] = duration

	print('duration (ms)', 'trx_id','1st seen', 'last seen' )
	for trx_id in sorted(all_trx, key=lambda k: all_trx[k]['duration'], reverse=True):
		curr = all_trx[trx_id]
		duration = curr['duration'] 
		if duration > MIN_DURATION:
			print(duration, trx_id, datetime.fromtimestamp(int(curr['first_seen']/1000)), datetime.fromtimestamp(int(curr['last_seen']/1000)))

read_log()
print_trx()