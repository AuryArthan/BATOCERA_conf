systems=('atari2600' 'c64' 'zxspectrum' 'pcengine' 'gb' 'gbc' 'gba' 'nds' 'virtualboy' 'nes' 'fds' 'snes' 'n64' 'gamecube' 'wii' 'gamegear' 'mastersystem' 'megadrive' 'sega32x' 'segacd' 'saturn' 'dreamcast' 'psp' 'psx' 'ps2' 'xbox' 'easyrpg' 'lutro' 'solarus' 'flash' 'dos' 'windows' 'ports')
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
	['gamecube']='ciso'
	['wii']='wbfs'
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
	['lutro']='lutro'
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
			if [ -f "./00Boxart/$filename" ]; then	# check if boxart exists
				echo -e '\t\t<image>./00Boxart/'$filename'</image>' >> gamelist.xml
			fi
			if [ -f "./00Logo/$filename" ]; then	# check if logo exists
				echo -e '\t\t<marquee>./00Logo/'$filename'</marquee>' >> gamelist.xml
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
	if [ -f "./00Logo/"${filename##*/} ]; then	# check if logo exists
		echo -e '\t\t<marquee>./00Logo/'${filename##*/}'</marquee>' >> gamelist.xml
	fi
	echo -e '\t</game>' >> gamelist.xml
done
echo '</gameList>' >> gamelist.xml
cd ..
