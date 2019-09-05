import json
import os
import subprocess
import re

def clean_name(mystr):
	spl = re.sub('[\s+]', '', mystr).split(':')
	if len(spl) != 2:
		return None
	else:
		return spl[0],spl[1]


def clean_count(mystr):
	spl = re.sub('[\s+]', '', mystr).split(':')
	if len(spl) != 2 or not spl[1].isdigit():
		return None
	else:
		return spl[0],int(filter(str.isdigit, spl[1]))
	

def clean_range(mystr):
	spl = re.sub('[\s+]', '', mystr).split(':')
	if len(spl) != 2:
		return None
	else:
		rng = spl[1].split("..")
		if len(rng) != 2 and all([re.match("^\d+?\.\d+?$", x) is not None for x in rng]):
			return None
		return spl[0],[float(x) for x in rng]


def clean_list(mystr):
	spl = re.sub('[\s+]', '', mystr).split(':')
	if not all([x.isdigit() for x in spl[1].split(',')]):
		return None
	else:
		return spl[0],[int(x) for x in spl[1].split(',')]
	

project_pxd = os.path.basename(os.getcwd())
mzmlfiles = [x for x in os.listdir('.') if x.endswith('.mzML')]

names = ["File name"]
counts = ["Number of spectra", "Number of peaks", "level 1", "level 2"]
ranges = ["retention time", "mass-to-charge", "intensity"]
lists = ["MS levels"]

filestats = list()

for f in mzmlfiles:
	d = dict()
	p = subprocess.Popen("FileInfo -in {f}".format(f=f), stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
	(output, err) = p.communicate()
	status = p.wait()
	#>0 is failure
	if status < 1:
		outstrings = filter(None, [x.lstrip() for x in output.split('\n')])
		for line in outstrings:
			for n in names:
				if n in line:
					tup = clean_name(line)
					if tup:
						d[tup[0]] = tup[1]
			for n in counts:
				if n in line:
					tup = clean_count(line)
					if tup:
						d[tup[0]] = tup[1]
			for n in ranges:
				if n in line:
					tup = clean_range(line)
					if tup:
						d[tup[0]] = tup[1]
			for n in lists:
				if n in line:
					tup = clean_list(line)
					if tup:
						d[tup[0]] = tup[1]
		filestats.append(d)

from os.path import dirname as up
two_up = up(up(os.getcwd()))

with open(os.path.join(two_up,"{pxd}_fileinfo.json".format(pxd=project_pxd)), 'w') as f:
	f.write(json.dumps({project_pxd: filestats}, indent=4))
	
