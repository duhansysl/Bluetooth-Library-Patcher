#!/usr/bin/env bash
#
# ======================================================================
#
#  Duhan's Kitchen V3.0
#
#  Copyright (C) 2025 duhansysl
#  Copyright (C) 2024 3arthur6
#  Copyright (C) 2024 PeterKnecht93
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ======================================================================
#
# shellcheck disable=SC2012,SC2024,SC2144
#

apex="com.android.btservices.apex"

choice=(
"OneUI 1.X - Android 9" 
"OneUI 2.X - Android 10" 
"OneUI 3.X - Android 11" 
"OneUI 4.X - Android 12" 
"OneUI 5.X - Android 13" 
"OneUI 6.X - Android 14" 
"OneUI 7.X - Android 15"
)
stock_hex=(
"88000034e8030032" 						# OneUI 1 stock
"........f4031f2af3031f2ae8030032" 		# OneUI 2 stock
"........f3031f2af4031f2a3e" 			# OneUI 3 stock
"........f9031f2af3031f2a41" 			# OneUI 4 stock
"6804003528008052" 						# OneUI 5 stock
"6804003528008052" 						# OneUI 6 stock
"480500352800805228cb1e39"				# OneUI 7 stock
)
patched_hex=(
"1f2003d5e8031f2a" 						# OneUI 1 patched
"1f2003d5f4031f2af3031f2ae8031f2a" 		# OneUI 2 patched
"1f2003d5f3031f2af4031f2a3e" 			# OneUI 3 patched
"1f2003d5f9031f2af3031f2a48" 			# OneUI 4 patched
"2a00001428008052" 						# OneUI 5 patched
"2b00001428008052" 						# OneUI 6 patched
"2a0000142800805228cb1e39"				# OneUI 7 patched
)

if ! [ -e "in" ]; then
	mkdir in
fi
if ! [ -e "tmp" ]; then
 	mkdir tmp
fi
if ! [ -e "lib_stock" ]; then
	mkdir lib_stock
fi
if ! [ -e "lib_patched" ]; then
	mkdir lib_patched
fi

clear
sleep 0.5
echo " "
echo; read -p " Please enter your sudo password properly: " pass
sudo -S <<< "$pass"
echo " "
clear
sleep 0.5

clear
echo "============================================================================================"
echo
echo "                              Bluetooth Library Patcher V2.1                                "
echo "        ---------------------------------------------------------------------------         "
echo "                                  Written by @duhansysl                                     "
echo
echo "============================================================================================"
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
echo "	7. OneUI 7.X - Android 15"
echo

read -p "Please make your choice (1-7): " choice

if [[ "$choice" =~ ^[1-7]$ ]]; then
    array_number=$((choice - 1))
    library="libbluetooth.so"
    [[ $choice -ge 5 ]] && library="libbluetooth_jni.so"
else
	echo 
	echo "-----------------------------------"
	echo " "	
    echo " ERROR: Invalid choice. Exiting."
	echo " "
	echo "-----------------------------------"		
    exit 1
fi

if [[ -f "in/$apex" ]]; then
    unzip -qj "in/$apex" "apex_payload.img" -d "tmp"
    mkdir -p tmp/mnt && sudo -S <<< "$pass" mount -o ro "tmp/apex_payload.img" "tmp/mnt"
    cp "tmp/mnt/lib64/$library" "tmp"
    cp "tmp/mnt/lib64/$library" "lib_stock"
    sudo -S <<< "$pass" umount "tmp/mnt"
elif [[ -f "in/$library" ]]; then
    cp "in/$library" "tmp/$library"
    cp "in/$library" "lib_stock"
else
	echo
	echo "-----------------------------------------------------------------------------------------------"
	echo " "
    echo "ERROR: Neither $apex nor $library found in the 'in' directory."
	echo " "
	echo "-----------------------------------------------------------------------------------------------"	
    exit 1
fi

if [[ "$choice" == "2" ]]; then
    echo "\nSelection: ${choice[$array_number]}"
    if xxd -p "tmp/$library" | tr -d '\n' | grep -q "....0034f3031f2af4031f2a....0014"; then
        stock_hex_value="....0034f3031f2af4031f2a....0014"
        patched_hex_value="1f2003d5f3031f2af4031f2a47000014"
    else
        stock_hex_value="${stock_hex[1]}"
        patched_hex_value="${patched_hex[1]}"
    fi
else
    stock_hex_value="${stock_hex[$array_number]}"
    patched_hex_value="${patched_hex[$array_number]}"
fi

if xxd -p "tmp/$library" | tr -d '\n' | grep -q "$patched_hex_value"; then
	echo "-------------------------------------------------------------------"
	echo " "
    echo " [ $patched_hex_value ] HEX patch is already applied in $library."
	echo " "
	echo "-------------------------------------------------------------------"	
    rm -rf tmp
    exit 0
fi

if ! xxd -p "tmp/$library" | tr -d '\n' | grep -q "$stock_hex_value"; then
	echo "-------------------------------------------------------------------"
	echo " "
    echo " There is no HEX value [ $stock_hex_value ] in $library."
	echo " "
	echo "-------------------------------------------------------------------"
    rm -rf tmp
    exit 1
fi

echo
echo " "
echo "Selection: ${choice[$array_number]}"
echo "----------------------------------"
echo " Patching [ ${stock_hex[$array_number]} ] HEX code to [ ${patched_hex[$array_number]} ] in $library"
echo " "
echo
sleep 2.0
xxd -p "tmp/$library" | tr -d '\n' | sed "s/$stock_hex_value/$patched_hex_value/" | xxd -r -p > "lib_patched/$library"
echo "------------------------------------------------------------------------------------"		
echo " "
echo " Successfully patched [ $library ] & copied it to lib_patched folder."
echo " "
echo "------------------------------------------------------------------------------------"		
echo
rm -rf tmp