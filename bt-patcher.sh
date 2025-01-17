#!/usr/bin/env bash
#
# ======================================================================
#
#  Duhan's Kitchen V2.0
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
choice=("OneUI 1.X - Android 9" "OneUI 2.X - Android 10" "OneUI 3.X - Android 11" "OneUI 4.X - Android 12" "OneUI 5.X - Android 13" "OneUI 6.X - Android 14")
stock_hex=("88000034e8030032" "........f4031f2af3031f2ae8030032" "........f3031f2af4031f2a3e" "........f9031f2af3031f2a41" "6804003528008052" "6804003528008052" "....0034f3031f2af4031f2a....0014")
patched_hex=("1f2003d5e8031f2a" "1f2003d5f4031f2af3031f2ae8031f2a" "1f2003d5f3031f2af4031f2a3e" "1f2003d5f9031f2af3031f2a48" "2a00001428008052" "2b00001428008052" "1f2003d5f3031f2af4031f2a47000014")

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
echo "                              Bluetooth Library Patcher V2.0                                "
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

if [[ "$choice" =~ ^[1-6]$ ]]; then
    array_number=$((choice - 1))
    library="libbluetooth.so"
    [[ $choice -ge 3 ]] && library="libbluetooth_jni.so"
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
    mkdir -p tmp/mnt && sudo mount -o ro "tmp/apex_payload.img" "tmp/mnt"
    cp "tmp/mnt/lib64/$library" "tmp"
    cp "tmp/mnt/lib64/$library" "lib_stock"
    sudo umount "tmp/mnt"
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
    if xxd -p "tmp/$library" | tr -d '\n' | grep -q "${stock_hex[6]}"; then
        stock_hex_value="${stock_hex[6]}"
        patched_hex_value="${patched_hex[6]}"
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
    echo "[ $patched_hex_value ] HEX patch is already applied in $library."
	echo " "
	echo "-------------------------------------------------------------------"	
    rm -rf tmp
    exit 0
fi

if ! xxd -p "tmp/$library" | tr -d '\n' | grep -q "$stock_hex_value"; then
	echo "-------------------------------------------------------------------"
	echo " "
    echo "There is no HEX value [ $stock_hex_value ] in $library."
	echo " "
	echo "-------------------------------------------------------------------"
    rm -rf tmp
    exit 1
fi

echo
echo " "
echo "Selection: ${choice[$array_number]}"
echo "----------------------------------"
echo "Patching [ ${stock_hex[$array_number]} ] HEX code to [ ${patched_hex[$array_number]} ] in $library"
echo " "
echo
sleep 2.0
xxd -p "tmp/$library" | tr -d '\n' | sed "s/$stock_hex_value/$patched_hex_value/" | xxd -r -p > "lib_patched/$library"
echo "------------------------------------------------------------------------------------"		
echo " "
echo "Successfully patched [ $library ] & copied it to lib_patched folder."
echo " "
echo "------------------------------------------------------------------------------------"		
echo
rm -rf tmp