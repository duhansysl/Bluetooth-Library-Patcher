#######################################################
####### Written by @duhansysl & @PeterKnecht ##########
#######################################################
#!/bin/bash

#[
APEX="com.android.btservices.apex"
LIBRARY="libbluetooth_jni.so"
LIBRARY_OLD="libbluetooth.so"
ONEUI1_FROM=88000034e8030032
ONEUI1_TO=1f2003d5e8031f2a
ONEUI2_FROM=........f4031f2af3031f2ae8030032
ONEUI2_TO=1f2003d5f4031f2af3031f2ae8031f2a
ONEUI2_2FROM=....0034f3031f2af4031f2a....0014
ONEUI2_2TO=1f2003d5f3031f2af4031f2a47000014
ONEUI3_FROM=........f3031f2af4031f2a3e
ONEUI3_TO=1f2003d5f3031f2af4031f2a3e
ONEUI4_FROM=........f9031f2af3031f2a41
ONEUI4_TO=1f2003d5f9031f2af3031f2a48
ONEUI5_FROM=6804003528008052
ONEUI5_TO=2a00001428008052
ONEUI6_FROM=6804003528008052
ONEUI6_TO=2b00001428008052
#]

		if ! [ -e "in" ]; then
			mkdir in
		fi
		if ! [ -e "lib_stock" ]; then
			mkdir lib_stock
		fi
		if ! [ -e "lib_patched" ]; then
			mkdir lib_patched
		fi		

clear
echo "############################################################################################"
echo
echo "                              Bluetooth Library Patcher V1.2                                "
echo "        --------------------------------------------------------------------------          "
echo "                                  Written by @duhansysl                                     "
echo
echo "############################################################################################"
echo
echo "Put bluetooth lib or bt-apex img to /in folder"
echo
echo "Warning! This selection is important for applying right HEX values, so choose the right version."
echo
echo "	1. OneUI 1.X - Android 9"
echo "	2. OneUI 2.X - Android 10"
echo "	3. OneUI 3.X - Android 11"
echo "	4. OneUI 4.X - Android 12"
echo "	5. OneUI 5.X - Android 13"
echo "	6. OneUI 6.X - Android 14"
echo

read -p "Please make your choice (1-6): " choice

case $choice in
    1)
		if ! [ -e "in/$LIBRARY_OLD" ]; then
			echo
			echo "--------------------------------------"
			echo " "
			echo "Error: [ $LIBRARY_OLD ] not found."
			echo 
			echo "--------------------------------------"			
			exit
		fi
		
		[ -d lib_patched ] && rm -rf lib_patched && rm -rf lib_stock
		[ -d tmp ] && rm -rf tmp
		mkdir -p lib_patched tmp lib_stock
		
		cp "in/$LIBRARY_OLD" "tmp/$LIBRARY_OLD"
		cp "in/$LIBRARY_OLD" "lib_stock"

		if xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI1_TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 1.X - Android 9"			
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI1_TO\ ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"	
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 0
		fi

		if ! xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI1_FROM"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 1.X - Android 9"
			echo "-------------------------------------------------------------------"
			echo " "
			echo " There is no HEX value [ \"$ONEUI1_FROM\ ] existed in & $LIBRARY_OLD."
			echo " "
			echo "-------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 1
		fi

		echo
		echo " "
		echo "Selection: OneUI 1.X - Android 9"
		echo "----------------------------------"
		echo "Patching [ \"$ONEUI1_FROM\" ] HEX code to [ \"$ONEUI1_TO\" ] in $LIBRARY_OLD"
		echo " "
		echo
		sleep 2.0
		xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | sed "s/$ONEUI1_FROM/$ONEUI1_TO/" | xxd -r -p > lib_patched/$LIBRARY_OLD
		echo "------------------------------------------------------------------------------------"		
		echo " "
		echo "Succesfully patched [ $LIBRARY_OLD ] & copied it to lib_patched folder."
		echo " "
		echo "------------------------------------------------------------------------------------"		
		echo

		[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
		rm -rf "tmp"
        ;;
	2)
		if ! [ -e "in/$LIBRARY_OLD" ]; then
			echo
			echo "----------------------------------"
			echo " "
			echo "Error: [ $LIBRARY_OLD ] not found."
			echo 
			echo "----------------------------------"			
			exit
		fi
		
		[ -d lib_patched ] && rm -rf lib_patched && rm -rf lib_stock
		[ -d tmp ] && rm -rf tmp
		mkdir -p lib_patched tmp lib_stock

		cp "in/$LIBRARY_OLD" "tmp/$LIBRARY_OLD"
		cp "in/$LIBRARY_OLD" "lib_stock"

		if xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI2_TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 2.X - Android 10"
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI2_TO\ ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"	
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"				
			exit 0
		fi
		
		if xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI2_2TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 2.X - Android 10"
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI2_2TO\ ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"	
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"				
			exit 1
		fi
		
		if ! xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI2_FROM" && ! xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI2_2FROM"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 2.X - Android 10"
			echo "-----------------------------------------------------------------------------------------------"
			echo " "
			echo " There is no HEX value [ \"$ONEUI2_FROM\" ] or [ \"$ONEUI2_2FROM\" ] existed in & $LIBRARY_OLD."
			echo " "
			echo "-----------------------------------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 2
		fi
		
		echo
		echo " "
		echo "Selection: OneUI 2.X - Android 10"			
		sleep 2.0
		
		if  xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI2_FROM"; then 
			echo "----------------------------------"
			echo "Patching [ \"$ONEUI2_FROM\" ] HEX code to [ \"$ONEUI2_TO\" ] in $LIBRARY_OLD"
			xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | sed "s/$ONEUI2_FROM/$ONEUI2_TO/" | xxd -r -p > lib_patched/$LIBRARY_OLD
		fi
		
		if  xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI2_2FROM"; then 
			echo "----------------------------------"
			echo "Patching [ \"$ONEUI2_2FROM\" ] HEX code to [ \"$ONEUI2_2TO\" ] in $LIBRARY_OLD"
			xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | sed "s/$ONEUI2_2FROM/$ONEUI2_2TO/" | xxd -r -p > lib_patched/$LIBRARY_OLD
		fi			
		
		echo
		echo
		echo "------------------------------------------------------------------------------------"		
		echo " "
		echo "Succesfully patched [ $LIBRARY_OLD ] & copied it to lib_patched folder."
		echo " "
		echo "------------------------------------------------------------------------------------"		
		echo

		[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
		rm -rf "tmp"
        ;;
	3)
		if ! [ -e "in/$LIBRARY_OLD" ]; then
			echo
			echo "----------------------------------"
			echo " "
			echo "Error: [ $LIBRARY_OLD ] not found."
			echo 
			echo "----------------------------------"			
			exit
		fi
		
		[ -d lib_patched ] && rm -rf lib_patched && rm -rf lib_stock
		[ -d tmp ] && rm -rf tmp
		mkdir -p lib_patched tmp lib_stock

		cp "in/$LIBRARY_OLD" "tmp/$LIBRARY_OLD"
		cp "in/$LIBRARY_OLD" "lib_stock"

		if xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI3_TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 3.X - Android 11"
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI3_TO\" ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 0
		fi

		if ! xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI3_FROM"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 3.X - Android 11"
			echo "-------------------------------------------------------------------"
			echo " "
			echo " There is no HEX value [ \"$ONEUI3_FROM\" ] existed in & $LIBRARY_OLD."
			echo " "
			echo "-------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 1
		fi

		echo
		echo " "
		echo "Selection: OneUI 3.X - Android 11"
		echo "----------------------------------"
		echo "Patching [ \"$ONEUI3_FROM\" ] HEX code to [ \"$ONEUI3_TO\" ] in $LIBRARY_OLD"
		echo " "
		echo
		sleep 2.0
		xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | sed "s/$ONEUI3_FROM/$ONEUI3_TO/" | xxd -r -p > lib_patched/$LIBRARY_OLD
		echo "------------------------------------------------------------------------------------"		
		echo " "
		echo "Succesfully patched [ $LIBRARY_OLD ] & copied it to lib_patched folder."
		echo " "
		echo "------------------------------------------------------------------------------------"		
		echo

		[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
		rm -rf "tmp"
        ;;
	4)
		if ! [ -e "in/$LIBRARY_OLD" ]; then
			echo
			echo "----------------------------------"
			echo " "
			echo "Error: [ $LIBRARY_OLD ] not found."
			echo 
			echo "----------------------------------"			
			exit
		fi
		
		[ -d lib_patched ] && rm -rf lib_patched && rm -rf lib_stock
		[ -d tmp ] && rm -rf tmp
		mkdir -p lib_patched tmp lib_stock

		cp "in/$LIBRARY_OLD" "tmp/$LIBRARY_OLD"
		cp "in/$LIBRARY_OLD" "lib_stock"

		if xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI4_TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 4.X - Android 12"
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI4_TO\" ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"	
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"				
			exit 0
		fi

		if ! xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | grep -q "$ONEUI4_FROM"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 4.X - Android 12"
			echo "-------------------------------------------------------------------"
			echo " "
			echo " There is no HEX value [ \"$ONEUI4_FROM\" ] existed in & $LIBRARY_OLD."
			echo " "
			echo "-------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 1
		fi

		echo
		echo " "
		echo "Selection: OneUI 4.X - Android 12"
		echo "----------------------------------"
		echo "Patching [ \"$ONEUI4_FROM\" ] HEX code to [ \"$ONEUI4_TO\" ] in $LIBRARY_OLD"
		echo " "
		echo
		sleep 2.0
		xxd -p "tmp/$LIBRARY_OLD" | tr -d \\n | tr -d " " | sed "s/$ONEUI4_FROM/$ONEUI4_TO/" | xxd -r -p > lib_patched/$LIBRARY_OLD
		echo "------------------------------------------------------------------------------------"		
		echo " "
		echo "Succesfully patched [ $LIBRARY_OLD ] & copied it to lib_patched folder."
		echo " "
		echo "------------------------------------------------------------------------------------"		
		echo

		[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
		rm -rf "tmp"
        ;;
	5)
		if ! [ -e "in/$LIBRARY" ] && ! [ -e "in/$APEX" ]; then
			echo
			echo "-----------------------------------------------------------------------------"
			echo " "
			echo "Error: [ $LIBRARY ] or [ $APEX ] not found."
			echo 
			echo "-----------------------------------------------------------------------------"			
			exit
		fi	
		
		[ -d lib_patched ] && rm -rf lib_patched && rm -rf lib_stock
		[ -d tmp ] && rm -rf tmp
		mkdir -p lib_patched tmp lib_stock

		if [[ -f "in/$APEX" ]]; then
			unzip -qj "in/$APEX" "apex_payload.img" -d "tmp"

			mkdir tmp/mnt && sudo mount -o ro "tmp/apex_payload.img" "tmp/mnt"
			cp "tmp/mnt/lib64/$LIBRARY" "tmp"
			cp "tmp/mnt/lib64/$LIBRARY" "lib_stock"	
		else
			cp "in/$LIBRARY" "tmp/$LIBRARY"
		fi

		if xxd -p "tmp/$LIBRARY" | tr -d \\n | tr -d " " | grep -q "$ONEUI5_TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 5.X - Android 13"
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI5_TO\" ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"	
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 0
		fi

		if ! xxd -p "tmp/$LIBRARY" | tr -d \\n | tr -d " " | grep -q "$ONEUI5_FROM"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 5.X - Android 13"
			echo "-------------------------------------------------------------------"
			echo " "
			echo " There is no HEX value [ \"$ONEUI5_FROM\" ] existed in & $LIBRARY."
			echo " "
			echo "-------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 1
		fi

		echo
		echo " "
		echo "Selection: OneUI 5.X - Android 13"
		echo "----------------------------------"
		echo "Patching [ \"$ONEUI5_FROM\" ] HEX code to [ \"$ONEUI5_TO\" ] in $LIBRARY"
		echo " "
		echo
		sleep 2.0
		xxd -p "tmp/$LIBRARY" | tr -d \\n | tr -d " " | sed "s/$ONEUI5_FROM/$ONEUI5_TO/" | xxd -r -p > lib_patched/$LIBRARY
		echo "------------------------------------------------------------------------------------"		
		echo " "
		echo "Succesfully patched [ $LIBRARY ] & copied it to lib_patched folder."
		echo " "
		echo "------------------------------------------------------------------------------------"		
		echo

		[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
		rm -rf "tmp"
        ;;
	6)
		if ! [ -e "in/$LIBRARY" ] && ! [ -e "in/$APEX" ]; then
			echo
			echo "-----------------------------------------------------------------------------"
			echo " "
			echo "Error: [ $LIBRARY ] or [ $APEX ] not found."
			echo 
			echo "-----------------------------------------------------------------------------"			
			exit
		fi	
		
		[ -d lib_patched ] && rm -rf lib_patched && rm -rf lib_stock
		[ -d tmp ] && rm -rf tmp
		mkdir -p lib_patched tmp lib_stock

		if [[ -f "in/$APEX" ]]; then
			unzip -qj "in/$APEX" "apex_payload.img" -d "tmp"

			mkdir tmp/mnt && sudo mount -o ro "tmp/apex_payload.img" "tmp/mnt"
			cp "tmp/mnt/lib64/$LIBRARY" "tmp"
			cp "tmp/mnt/lib64/$LIBRARY" "lib_stock"	
		else
			cp "in/$LIBRARY" "tmp/$LIBRARY"
		fi

		if xxd -p "tmp/$LIBRARY" | tr -d \\n | tr -d " " | grep -q "$ONEUI6_TO"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 6.X - Android 14"
			echo "-------------------------------------------------------------------"
			echo " "
			echo "[ \"$ONEUI6_TO\" ] HEX patch is already applied in library."
			echo " "
			echo "-------------------------------------------------------------------"	
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 0
		fi

		if ! xxd -p "tmp/$LIBRARY" | tr -d \\n | tr -d " " | grep -q "$ONEUI6_FROM"; then
			sleep 2.0
			echo
			echo "Selection: OneUI 6.X - Android 14"
			echo "-------------------------------------------------------------------"
			echo " "
			echo " There is no HEX value [ \"$ONEUI6_FROM\" ] existed in & $LIBRARY."
			echo " "
			echo "-------------------------------------------------------------------"
			[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
			rm -rf "tmp"			
			exit 1
		fi

		echo
		echo " "
		echo "Selection: OneUI 6.X - Android 14"
		echo "----------------------------------"		
		echo "Patching [ \"$ONEUI6_FROM\" ] HEX code to [ \"$ONEUI6_TO\" ] in $LIBRARY"
		echo " "
		echo
		sleep 2.0
		xxd -p "tmp/$LIBRARY" | tr -d \\n | tr -d " " | sed "s/$ONEUI6_FROM/$ONEUI6_TO/" | xxd -r -p > lib_patched/$LIBRARY
		echo "------------------------------------------------------------------------------------"		
		echo " "
		echo "Succesfully patched [ $LIBRARY ] & copied it to lib_patched folder."
		echo " "
		echo "------------------------------------------------------------------------------------"		
		echo

		[ -d "tmp/mnt" ] && sudo umount "tmp/mnt"
		rm -rf "tmp"
        ;;
    *)	 
		echo
        echo "Invalid selection. Please make your choice between 1 and 6 !!!"
		echo
        ;;
esac