#!/bin/bash
find . -type f -daystart -mtime "-${1:-7}" -not -iname '*.r??' -not -iname '*.ifo' -not -iname '*.bup' -not -iname '*.sub' -not -iname '*.idx' -not -iname '*.nfo' -not -iname '*.nzb' -not -iname '*.srr' -not -iname '*.srt' -not -iname '*.DS_Store' -not -iname '*.ignore' -not -iname '*.txt' -printf '%T@;%p\n' | sort -n | while IFS=";" read time file; do
	mtime=$(date -d @${time} +%c)
	echo "${mtime} \"${file}\""
done
