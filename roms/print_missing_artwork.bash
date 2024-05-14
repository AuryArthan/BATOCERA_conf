systems=('atari2600' 'zxspectrum' 'c64' 'pcengine' 'gb' 'gbc' 'gba' 'nds' '3ds' 'virtualboy' 'nes' 'fds' 'snes' 'n64' 'gamecube' 'mastersystem' 'megadrive' 'sega32x' 'segacd' 'saturn' 'dreamcast' 'psp' 'psx' 'ps2' 'flash' 'easyrpg' 'windows' 'ports')
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
	['n64']='z64 n64'
	['gamecube']='ciso m3u'
	['mastersystem']='sms'
	['megadrive']='md bin'
	['sega32x']='32x'
	['segacd']='m3u'
	['saturn']='m3u'
	['dreamcast']='m3u cdi'
	['psp']='iso'
	['psx']='m3u'
	['ps2']='iso'
	['flash']='swf'
	['easyrpg']='zip'
	['windows']='pc wsquashfs'
	['ports']='sh'
)

for system in ${systems[@]}; do
	echo -e '\n'$system
	cd $system
	declare -a extensions=(${extensions_system[$system]})
	for extension in ${extensions[@]}; do
		echo -e '\t.'$extension
		for ffilename in *.$extension; do
			filename=${ffilename%.*}
			if ! [ -f "./00Boxart/$filename" ]; then
				echo -e '\t\t'$filename
			fi
		done
	done
	cd ..
done
