systems=('atari2600' 'zxspectrum' 'c64' 'pcengine' 'gb' 'gbc' 'gba' 'nds' '3ds' 'virtualboy' 'nes' 'fds' 'snes' 'n64' 'gamecube' 'wii' 'mastersystem' 'megadrive' 'sega32x' 'segacd' 'saturn' 'dreamcast' 'psp' 'psx' 'ps2' 'xbox' 'flash' 'shockwave' 'easyrpg' 'solarus' 'windows' 'lutro' 'ecwolf' 'ports')
declare -A extensions_system=( 
	['atari2600']='a26'
	['zxspectrum']='z80'
	['c64']='d64 prg t64 crt m3u'
	['pcengine']='pce'
	['gb']='gb'
	['gbc']='gbc'
	['gba']='gba'
	['nds']='nds'
	['3ds']='3ds'
	['virtualboy']='vb'
	['nes']='nes'
	['fds']='fds'
	['snes']='sfc smc'
	['n64']='z64 n64 v64'
	['gamecube']='ciso nkit.iso m3u'
	['wii']='wbfs'
	['mastersystem']='sms'
	['megadrive']='md bin'
	['sega32x']='32x'
	['segacd']='m3u'
	['saturn']='m3u'
	['dreamcast']='m3u cdi'
	['psp']='iso'
	['psx']='m3u'
	['ps2']='iso'
	['xbox']='xiso.iso'
	['flash']='swf'
	['shockwave']='dcr'
	['easyrpg']='zip'
	['solarus']='solarus'
	['windows']='pc wsquashfs'
	['lutro']='lutro'
	['ecwolf']='ecwolf'
	['ports']='sh'
)
declare -A system_placeholders=(
	['gb']='Wario_Land Super_Mario_Land'
	['gba']='Pokemon'
	['nes']='SMB2 SMB Aladdin'
	['n64']='Super_Mario_64 Legend_of_Zelda,_The Donkey_Kong_64 _(CHN)'
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
			filename=${ffilename%.$extension} # remove extension
			name="${filename//_/' '}" # replace underscores with spaces
			if [[ "$name" == *")"* ]]; then
				name="${name%%)*})" # remove everything after first bracket
			fi
			echo -e '\t<game>' >> gamelist.xml
			echo -e '\t\t<path>./'$filename'.'$extension'</path>' >> gamelist.xml
			echo -e '\t\t<name>'$name'</name>' >> gamelist.xml
			if [ -f "./00Boxart/$filename" ]; then # check if boxart exists, otherwise use placeholder
				echo -e '\t\t<image>./00Boxart/'$filename'</image>' >> gamelist.xml
			else
				found=0
				for ph in ${system_placeholders[@]}; do # check if there is a specific placeholder
					if [[ $name == *${ph//_/' '}* ]]; then
						echo -e '\t\t<image>./00Boxart/00placeholder - '${ph//_/' '}'</image>' >> gamelist.xml
						found=1
						break
					fi
				done
				if [[ $found != 1 ]]; then
					echo -e '\t\t<image>./00Boxart/00placeholder</image>' >> gamelist.xml # if specific placeholder not found use generic placeholder
				fi
			fi
			echo -e '\t</game>' >> gamelist.xml
		done
	done
	echo '</gameList>' >> gamelist.xml
	cd ..
done

# pico8 is easy, the roms are the boxart
echo -e '\npico8'
cd pico8
rm gamelist.xml
echo '<?xml version="1.0" encoding="UTF-8"?>' >> gamelist.xml
echo '<gameList>' >> gamelist.xml
echo -e '\t.p8'
for ffilename in *.p8; do
	filename=${ffilename%.*}
	echo -e '\t<game>' >> gamelist.xml
	echo -e '\t\t<path>./'$filename'.p8</path>' >> gamelist.xml
	echo -e '\t\t<name>'${filename%/*}'</name>' >> gamelist.xml
	echo -e '\t\t<image>./'${filename##*/}'.p8</image>' >> gamelist.xml
	echo -e '\t</game>' >> gamelist.xml
done
echo '</gameList>' >> gamelist.xml
cd ..

# scummvm separate because it is in folders and I want to use the folder names
echo -e '\nscummvm'
cd scummvm
rm gamelist.xml
echo '<?xml version="1.0" encoding="UTF-8"?>' >> gamelist.xml
echo '<gameList>' >> gamelist.xml
echo -e '\t.scummvm'
for ffilename in */*.scummvm; do
	filename=${ffilename%.*}
	echo -e '\t<game>' >> gamelist.xml
	echo -e '\t\t<path>./'$filename'.scummvm</path>' >> gamelist.xml
	echo -e '\t\t<name>'${filename%/*}'</name>' >> gamelist.xml
	echo -e '\t\t<image>./00Boxart/'${filename##*/}'</image>' >> gamelist.xml
	echo -e '\t</game>' >> gamelist.xml
done
echo '</gameList>' >> gamelist.xml
cd ..
