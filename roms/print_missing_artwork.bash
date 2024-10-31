systems=('atari2600' 'c64' 'zxspectrum' 'pcengine' 'gb' 'gbc' 'gba' 'nds' 'virtualboy' 'nes' 'fds' 'snes' 'n64' 'gamecube' 'wii' 'gamegear' 'mastersystem' 'megadrive' 'sega32x' 'segacd' 'saturn' 'dreamcast' 'psp' 'psx' 'ps2' 'xbox' 'easyrpg' 'wswan' 'wswanc' 'lutro' 'pico8' 'solarus' 'flash' 'dos' 'windows' 'ports')
declare -A extensions_system=( 
	['atari2600']='a26'
	['c64']='d64'
	['zxspectrum']='z80'
	['pcengine']='pce'
	['gb']='gb'
	['gbc']='gbc'
	['gba']='gba'
	['nds']='nds zip'
	['virtualboy']='vb'
	['nes']='nes'
	['fds']='fds'
	['snes']='sfc smc'
	['n64']='z64'
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
	declare -a extensions=(${extensions_system[$system]})
	for extension in ${extensions[@]}; do
		echo -e '\t.'$extension
		for ffilename in *.$extension; do
			filename=${ffilename%.$extension}
			if ! [ -f "./00Boxart/$filename" ]; then
				echo -e '\t\t'$filename
			fi
			if ! [ -f "./00Logo/$filename" ]; then
				echo -e '\t\t[LOGO] '$filename
			fi
		done
	done
	cd ..
done
