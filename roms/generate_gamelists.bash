systems=('atari2600' 'c64' 'zxspectrum' 'pcengine' 'gb' 'gbc' 'gba' 'nds' 'virtualboy' 'nes' 'fds' 'snes' 'n64' 'n64_hacks' 'gamecube' 'wii' 'gamegear' 'mastersystem' 'megadrive' 'sega32x' 'segacd' 'saturn' 'dreamcast' 'psp' 'psx' 'ps2' 'xbox' 'easyrpg' 'wswan' 'wswanc' 'lutro' 'pico8' 'solarus' 'flash' 'dos' 'windows' 'ports')
declare -A extensions_system=( 
	['atari2600']='a26'
	['c64']='d64'
	['zxspectrum']='z80'
	['pcengine']='pce'
	['gb']='gb'
	['gbc']='gbc'
	['gba']='gba'
	['nds']='nds'
	['virtualboy']='vb'
	['nes']='nes'
	['fds']='fds'
	['snes']='sfc smc'
	['n64']='z64'
	['n64_hacks']='z64 n64'
	['gamecube']='ciso iso m3u'
	['wii']='wbfs rvz'
	['gamegear']='gg'
	['mastersystem']='sms'
	['megadrive']='md'
	['sega32x']='32x'
	['segacd']='m3u'
	['saturn']='m3u'
	['dreamcast']='m3u cdi'
	['psp']='iso'
	['psx']='m3u'
	['ps2']='iso'
	['xbox']='xiso.iso'
	['easyrpg']='zip'
	['wswan']='ws'
	['wswanc']='wsc'
	['lutro']='lutro'
	['pico8']='png'
	['solarus']='solarus'
	['flash']='swf'
	['dos']='iso'
	['windows']='pc'
	['ports']='sh'
)

for system in ${systems[@]}; do
	echo -e '\n'$system
	cd $system
	rm gamelist.xml
	echo '<?xml version="1.0"?>' >> gamelist.xml
	echo '<gameList>' >> gamelist.xml
	declare -a extensions=(${extensions_system[$system]})
	for extension in ${extensions[@]}; do
		echo -e '\t.'$extension
		for ffilename in *.$extension; do
			filename=${ffilename%.$extension}							# remove extension
			name=$(echo "$filename" | sed 's/ *(.*//')					# remove everything after brackets
			name=$(echo "$name" | sed 's/\(.*\), The\(.*\)/The \1\2/')	# put "The" at the beginning
			echo -e '\t<game>' >> gamelist.xml
			echo -e '\t\t<path>./'$filename'.'$extension'</path>' >> gamelist.xml
			echo -e '\t\t<name>'$name'</name>' >> gamelist.xml
			if [ -f "./00Image/$filename" ]; then	# check if image exists
				echo -e '\t\t<image>./00Image/'$filename'</image>' >> gamelist.xml
				if [ -f "./00Boxart/$filename" ]; then	# if so, check if boxart exists and put it as "thumbnail"
					echo -e '\t\t<thumbnail>./00Boxart/'$filename'</thumbnail>' >> gamelist.xml
				fi
			else
				if [ -f "./00Boxart/$filename" ]; then	# else, check if boxart exists and put it as "image" and "thumbnail"
					echo -e '\t\t<image>./00Boxart/'$filename'</image>' >> gamelist.xml
					echo -e '\t\t<thumbnail>./00Boxart/'$filename'</thumbnail>' >> gamelist.xml
				fi
			fi
			if [ -f "./00Logo/$filename" ]; then	# check if logo exists
				echo -e '\t\t<marquee>./00Logo/'$filename'</marquee>' >> gamelist.xml
			fi
			if [ -f "./00Cart/$filename" ]; then	# check if cart exists
				echo -e '\t\t<cartridge>./00Cart/'$filename'</cartridge>' >> gamelist.xml
			else
				if [ -f "./00Cart/00Placeholder" ]; then	# check if cart placeholder exists
					echo -e '\t\t<cartridge>./00Cart/00Placeholder</cartridge>' >> gamelist.xml
				fi
			fi
			if [ -f "./00description.json" ]; then	# check if descriptions exist
				game=$(jq -c --arg path "./$filename.$extension" '.games[] | select(.path == $path)' "./00description.json")
				if [ -n "$game" ]; then		# check if the chosen game description exists
					echo -e "\t\t<desc>$(echo "$game" | jq -r '.desc // ""' | sed 's/&/\&amp;/g')</desc>" >> gamelist.xml
					echo -e "\t\t<releasedate>$(echo "$game" | jq -r '.releasedate // ""' | sed 's/&/\&amp;/g')</releasedate>" >> gamelist.xml
					echo -e "\t\t<developer>$(echo "$game" | jq -r '.developer // ""' | sed 's/&/\&amp;/g')</developer>" >> gamelist.xml
					echo -e "\t\t<publisher>$(echo "$game" | jq -r '.publisher // ""' | sed 's/&/\&amp;/g')</publisher>" >> gamelist.xml
					echo -e "\t\t<genre>$(echo "$game" | jq -r '.genre // ""' | sed 's/&/\&amp;/g')</genre>" >> gamelist.xml
					echo -e "\t\t<players>$(echo "$game" | jq -r '.players // ""' | sed 's/&/\&amp;/g')</players>" >> gamelist.xml
					echo -e "\t\t<lang>$(echo "$game" | jq -r '.lang // "en"' | sed 's/&/\&amp;/g')</lang>" >> gamelist.xml
				fi
			fi
			echo -e '\t</game>' >> gamelist.xml
		done
	done
	echo '</gameList>' >> gamelist.xml
	cd ..
done

# scummvm, use folder names
echo -e '\nscummvm'
cd scummvm
rm gamelist.xml
echo '<?xml version="1.0"?>' >> gamelist.xml
echo '<gameList>' >> gamelist.xml
echo -e '\t.scummvm'
for ffilename in */*.scummvm; do
	filename=${ffilename%.*}
	echo -e '\t<game>' >> gamelist.xml
	echo -e '\t\t<path>./'$filename'.scummvm</path>' >> gamelist.xml
	echo -e '\t\t<name>'${filename%/*}'</name>' >> gamelist.xml
	echo -e '\t\t<image>./00Boxart/'${filename##*/}'</image>' >> gamelist.xml
	echo -e '\t\t<thumbnail>./00Boxart/'${filename##*/}'</thumbnail>' >> gamelist.xml
	echo -e '\t\t<marquee>./00Logo/'${filename##*/}'</marquee>' >> gamelist.xml
	if [ -f "./00description.json" ]; then	# check if descriptions exist
		game=$(jq -c --arg path "./$filename.scummvm" '.games[] | select(.path == $path)' "./00description.json")
		if [ -n "$game" ]; then		# check if the chosen game description exists
			echo -e "\t\t<desc>$(echo "$game" | jq -r '.desc // ""' | sed 's/&/\&amp;/g')</desc>" >> gamelist.xml
			echo -e "\t\t<releasedate>$(echo "$game" | jq -r '.releasedate // ""' | sed 's/&/\&amp;/g')</releasedate>" >> gamelist.xml
			echo -e "\t\t<developer>$(echo "$game" | jq -r '.developer // ""' | sed 's/&/\&amp;/g')</developer>" >> gamelist.xml
			echo -e "\t\t<publisher>$(echo "$game" | jq -r '.publisher // ""' | sed 's/&/\&amp;/g')</publisher>" >> gamelist.xml
			echo -e "\t\t<genre>$(echo "$game" | jq -r '.genre // ""' | sed 's/&/\&amp;/g')</genre>" >> gamelist.xml
			echo -e "\t\t<players>$(echo "$game" | jq -r '.players // ""' | sed 's/&/\&amp;/g')</players>" >> gamelist.xml
			echo -e "\t\t<lang>$(echo "$game" | jq -r '.lang // "en"' | sed 's/&/\&amp;/g')</lang>" >> gamelist.xml
		fi
	fi
	echo -e '\t</game>' >> gamelist.xml
done
echo '</gameList>' >> gamelist.xml
cd ..
