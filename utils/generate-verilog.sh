LIST_STD="DefaultConfig \
	  DefaultConfigNoFPU \
	  LightDefaultConfig \
	  LightDefaultConfigNoFPU \
	  DualCoreConfig "

# LIST_RBB="DefaultConfigRBB \
# 	  DefaultConfigNoFPURBB \
# 	  LightDefaultConfigRBB \
# 	  LightDefaultConfigNoFPURBB "

# LIST_DBG="DefaultConfig \
# 	  DefaultConfigNoFPU \
# 	  LightDefaultConfig \
# 	  LightDefaultConfigNoFPU \
# 	  DualCoreConfig "

echo ">> Building Verilog for Standard Configs"	
for f in $LIST_STD; do
	if [ ! -f "$f/freechips.rocketchip.system.$f.v" ]; then
		echo "		> $f"
		echo "		  make verilog CONFIG=$f"
		make verilog CONFIG=$f
	fi
done

# echo ">> Building RBB Emulators"	
# for f in $LIST_RBB; do
# 	if [ ! -f "emu-$f" ]; then
# 		echo "		> $f"
# 		echo "		  make CONFIG=$f"
# 		#make CONFIG=$f
# 	fi
# done

# echo ">> Building Debugging Emulators"	
# for f in $LIST_DBG; do
# 	if [ ! -f "emu-$f" ]; then
# 		echo "		> $f"
# 		echo "		  make debug CONFIG=$f"
# 		#make debug CONFIG=$f
# 	fi
# done