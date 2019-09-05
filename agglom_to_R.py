import json
import os
import subprocess
import re
import pandas as pd

infos = dict()
li = list()

fileinfos = [x for x in os.listdir('.') if x.endswith('_fileinfo.json')]
for jsnf in fileinfos:
	with open(jsnf) as f:
		j = json.load(f)
		infos.update(j)
		project, dicts_in_lists = j.iteritems().next()
		if dicts_in_lists:
			for x in dicts_in_lists:
				x["Project"]=project
			li.append(dicts_in_lists)

flat_list = [item for sublist in li for item in sublist]

df = pd.DataFrame(flat_list)
df['MSlevels'] = df['MSlevels'].astype(str)
df = pd.concat([df, 
	pd.DataFrame(df.retentiontime.values.tolist(), columns=['RT_min', 'RT_max']),
	pd.DataFrame(df.intensity.values.tolist(), columns=['i_min', 'i_max']),
	pd.DataFrame(df["mass-to-charge"].values.tolist(), columns=['MZ_min', 'MZ_max'])], 
		axis=1)

df = df.rename(index=str, columns={"level1": "Spectraatlevel1", "level2": "Spectraatlevel2"})
df.to_csv("now_to_r.csv", columns=[u'Filename', u'MSlevels', u'Numberofpeaks', 
u'Numberofspectra', u'Project', 
u'Spectraatlevel1', u'Spectraatlevel2', u'RT_min', u'RT_max', 
u'i_min', u'i_max', u'MZ_min', u'MZ_max'])

