for f in emulator-freechips.rocketchip.system-*; do
	echo "mv $f emu-${f:37}"
	mv $f emu-${f:37}
#	mv "$f" "${f:37}" 
done