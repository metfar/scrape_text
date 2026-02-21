#!/bin/bash
#  
#  Copyright 2018- William Martinez Bas <metfar@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#

if [ "q$1" == "q--help" -o "q$1" == "q-h" ]; then
	echo -en "$0 -h|--help \n		Displays this help\n\n";
	echo -en "$0 [urls.txt] [scraped_text]\n		Scrapes texts from urls to scraped text directory\n";
	exit 0;
fi;

URL_FILE="${1:-urls.txt}";
OUT_DIR="${2:-scraped_text}";
mkdir -p "${OUT_DIR}" 2>/dev/null;# create directory if it doesn't exist

i=0;# number of website from 0

# read URL_FILE with urls by line into variable url
while IFS= read -r url; do
	[[ -z "${url}" ]] && continue; # 				if line is empty
	[[ "${url}" =~ ^[[:space:]]*# ]] && continue; #or a comment, skip

	out_file="${OUT_DIR}/site_${i}.txt";

	
	curl -fsSL "${url}" \
		| grep -Eoi '<h1[^>]*>[^<]*</h1>|<p[^>]*>[^<]*</p>' \
		| tr '\n' ' ' \
		| tr -s ' ' \
		| tr '<>' '\n\n' \
		| grep -Ev '^(h1|/h1|p|/p|[[:space:]]*)$' \
		> "${out_file}";	# curl to get only h1/p lines, 
							# remove tags, normalize spaces 
							# to DIR/site_(number_of_website).txt

	echo "=== ${url} -> ${out_file} ===";
	cat "${out_file}";
	echo;

	i=$((i+1));
done < "${URL_FILE}" 2>/dev/null; #avoid shown errors

exit 0;
