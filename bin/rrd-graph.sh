#!/usr/local/bin/bash

rrd_dir="/var/db/rrdbot"
out_dir="/srv/www/beastie.jammm.eu.org/graph"

now="`date '+%Y-%m-%d %H:%M:%S%z'`"

# faad, nicht unterscheidbar schlechter kontrast
#color_list=("#00ff00" "#ff0000" "#0000ff" "#ffff00" "#00ffff" "#ff00ff")

# color wheel sortiert
#color_list=("#8a56e2" "#cf56e2" "#e256ae" "#e25668" "#e28956" "#e2cf56" "#aee256" "#68e256" "#56e289" "#56e2cf" "#56aee2" "#5668e2")

# color wheel mixed up
color_list=("#8a56e2" "#e25668" "#aee256" "#56e2cf" "#cf56e2" "#e28956" "#68e256" "#56aee2" "#e256ae" "#e2cf56" "#56e289" "#5668e2")

color_index=-1
next_color() {
	let color_index++
	if [[ $color_index -ge ${#color_list[@]} ]]; then
		color_index=0
	fi
	color="${color_list[color_index]}"
}

graph() {
	file="${1}"
	def=""
	line=""
	print=""
	ds="`rrdtool info "${file}" | sed -E '/^ds/!d;s/^ds\[([^]]*).*$/\1/' | uniq`"
	for source in ${ds}; do
		next_color
		def+="DEF:${source}=${file}:${source}:AVERAGE "
		line+="LINE1:${source}${color}:${source} GPRINT:${source}:LAST:%7.2lf%s GPRINT:${source}:AVERAGE:Average\\:%7.2lf%s GPRINT:${source}:MAX:Maximum\\:%7.2lf%s\\n "
	done
	tmp="$(basename $file)"
	title="${tmp%.rrd}"
	file_png="${out_dir%/}/${title}.png"
	rrdtool graph "${file_png}" --start "end-6h" -w 530 -h 260 -D --border 0 -t "${title}" -W "beastie.jammm.eu.org ${now}" ${def}${line}${print} 2>&1 >/dev/null
}


find "${rrd_dir}" -type f -iname '*.rrd' | while read rrdfile; do
	graph "${rrdfile}"
done
