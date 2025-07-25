#!/usr/bin/env bash
#
# ======================================================================
#
#  Duhan's Kitchen V3.0
#  Bluetooth Library Patcher V3.4
#
#  Copyright (C) 2025 duhansysl
#  Copyright (C) 2024 3arthur6
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

# ======================================================================================================
# ================================== Function HEX Values - Assignments =================================
# ======================================================================================================

bt_old="libbluetooth.so"
bt_new="libbluetooth_jni.so"
apex="com.android.btservices.apex"

s_1=("88000034e8030032")
s_2=("....0034f3031f2af4031f2a....0014" "........f4031f2af3031f2ae8030032")
s_3=("........f3031f2af4031f2a3e")
s_4=("........f9031f2af3031f2a41")
s_5=("6804003528008052")
s_6=("6804003528008052")
s_7=("480500352800805228cb1e39" "4805003528008052284b1e39" "1ff828ab5e39480500352800805228ab")
s_8=("97753948050037360080" "97773948050037360080")

p_1=("1f2003d5e8031f2a")
p_2=("1f2003d5f3031f2af4031f2a47000014" "1f2003d5f4031f2af3031f2ae8031f2a")
p_3=("1f2003d5f3031f2af4031f2a3e")
p_4=("1f2003d5f9031f2af3031f2a48")
p_5=("2a00001428008052")
p_6=("2b00001428008052")
p_7=("2a0000142800805228cb1e39" "2a00001428008052284b1e39" "1ff828ab5e392a0000142800805228ab")
p_8=("9775392a000014360080" "9777392a000014360080")

# ======================================================================================================
# ================================== Creating Workarea =================================================
# ======================================================================================================

	check_and_install() {
		PACKAGE_NAME="$1"
		PACKAGE_DESC="$2"

		if ! dpkg-query -W -f='${Status}' "$PACKAGE_NAME" 2>/dev/null | grep -q "ok installed"; then 
			clear; echo; echo
			echo " --> ⛔ ERROR: $PACKAGE_NAME is missing and is required for $PACKAGE_DESC."
			echo
			read -p " --> Do you want to install $PACKAGE_NAME? This requires sudo privileges. (y/n) > " USER_REPLY
			echo
			if [ "$USER_REPLY" = "y" ]; then
				echo " --> Installing $PACKAGE_NAME..."
				sudo apt update
				sudo apt install -y "$PACKAGE_NAME"
				if ! dpkg-query -W -f='${Status}' "$PACKAGE_NAME" 2>/dev/null | grep -q "ok installed"; then
					echo " --> ⛔ ERROR: Failed to install $PACKAGE_NAME. Please try installing it manually."
					exit 0
				else
					echo " --> ✅ SUCCESS: $PACKAGE_NAME installed successfully. Now run the script again."
					exit 0
				fi
			else
				echo " --> ⚠️ WARNING: Please install $PACKAGE_NAME with:"
				echo "     sudo apt install $PACKAGE_NAME"
				echo "     and try again."
				echo
				exit 0
			fi
		fi
	}

	declare -A packages=(
		[xxd]="HEX patches"
		[unzip]="extracting library from apex image"
	)

	for pkg in "${!packages[@]}"; do
		check_and_install "$pkg" "${packages[$pkg]}"
	done

	if ! [ -e "in" ] || ! [ -e "lib_stock" ] || ! [ -e "lib_patched" ]; then
		clear; sleep 0.5
		echo; echo; echo " --> ⛔ ERROR: Needed folders were not created before. Run script again!"
		echo; echo
		mkdir -p "in" "lib_stock" "lib_patched"
		exit
	fi 
	rm -fr lib_stock/* lib_patched/*
	if [ -e "in/$bt_old" ] && [ -e "in/$apex" ] || [ -e "in/$bt_new" ] && [ -e "in/$apex" ]|| [ -e "in/$bt_old" ] && [ -e "in/$bt_new" ]; then
		clear; sleep 0.5
		echo; echo; echo " --> ⛔ ERROR: Put either bluetooth library or apex IMG to in folder!"
		echo " --> ⚠️ WARNING: Only put one file."
		echo; echo
		exit
	fi	

# ======================================================================================================
# ================================== User Interface ====================================================
# ======================================================================================================
 
	clear; sleep 0.5; echo; read -p " --> Please enter your sudo password properly: " pass
	clear
	sleep 0.5
	echo "============================================================================================"
	echo 
	echo "                               Welcome to Duhan's Kitchen                                   "
	echo "        --------------------------------------------------------------------------          "
	echo "                  Bluetooth Library Patcher V3.4 - OneUI 1/2/3/4/5/6/7/8                    "
	echo
	echo "============================================================================================"
	sleep 0.5
	echo
	echo " ⚠️ WARNING: Put bluetooth lib or bt-apex img to /in folder"
	echo
	echo " ⚠️ WARNING: This selection is important for applying right HEX values, choose the right version"
	echo
	echo "	1. OneUI 1.X - Android 9"
	echo "	2. OneUI 2.X - Android 10"
	echo "	3. OneUI 3.X - Android 11"
	echo "	4. OneUI 4.X - Android 12"
	echo "	5. OneUI 5.X - Android 13"
	echo "	6. OneUI 6.X - Android 14"
	echo "	7. OneUI 7.X - Android 15"
	echo "	8. OneUI 8.X - Android 16"
	echo
	read -p "Please make your choice (1-8): " choice
	
# ======================================================================================================
# ================================== Processing ========================================================
# ======================================================================================================

	if [[ "$choice" =~ ^[8]$ ]]; then
		apex="com.android.bt.apex"
	fi

	if [[ "$choice" =~ ^[1-4]$ ]]; then
		library="$bt_old"
		mkdir -p "tmp/mnt"
		if [[ -f "in/$apex" ]]; then
			unzip -qj "in/$apex" "apex_payload.img" -d "tmp"
			sudo -S <<< "$pass" mount -o ro "tmp/apex_payload.img" "tmp/mnt" 2>/dev/null
			cp "tmp/mnt/lib64/$library" "tmp"; cp "tmp/mnt/lib64/$library" "lib_stock"
			sudo -S <<< "$pass" umount "tmp/mnt" 2>/dev/null
		elif [[ -f "in/$library" ]]; then
			cp "in/$library" "tmp/$library"; cp "in/$library" "lib_stock"
		else
			echo; echo " --> ⛔ ERROR: Neither $apex nor $library found in the 'in' directory."
			echo
			exit 1
		fi
	elif [[ "$choice" =~ ^[5-8]$ ]]; then
		library="$bt_new"
		mkdir -p "tmp/mnt"
		if [[ -f "in/$apex" ]]; then
			unzip -qj "in/$apex" "apex_payload.img" -d "tmp"
			sudo -S <<< "$pass" mount -o ro "tmp/apex_payload.img" "tmp/mnt" 2>/dev/null
			cp "tmp/mnt/lib64/$library" "tmp"; cp "tmp/mnt/lib64/$library" "lib_stock"
			sudo -S <<< "$pass" umount "tmp/mnt" 2>/dev/null
		elif [[ -f "in/$library" ]]; then
			cp "in/$library" "tmp/$library"; cp "in/$library" "lib_stock"
		else
			echo; echo " --> ⛔ ERROR: Neither $apex nor $library found in the 'in' directory."
			echo
			exit 1
		fi
	else
		echo; echo " --> ⛔ ERROR: Invalid choice. Exiting."
		echo
		exit 1
	fi
	
# ======================================================================================================
# ================================== HEX Patch Application =============================================
# ======================================================================================================

s_var="s_$choice[@]"
p_var="p_$choice[@]"
s_arr=("${!s_var}")
p_arr=("${!p_var}")

	echo; echo " --> Patching started..."
	hex_dump=$(xxd -p "tmp/$library" | tr -d '\n')
	patched=false

	for i in "${!s_arr[@]}"; do
		sig="${s_arr[$i]}"
		patch="${p_arr[$i]}"
		sig_regex=$(echo "$sig" | sed -E 's/\.\.\.\./[0-9a-f]{4}/g' | sed -E 's/\.\.\./[0-9a-f]{3}/g' | sed -E 's/\.\./[0-9a-f]{2}/g' | sed -E 's/\./[0-9a-f]/g')

		if echo "$hex_dump" | grep -qE "$patch"; then
			echo " --> Checking HEX '$sig': Already patched."
		elif echo "$hex_dump" | grep -qE "$sig_regex"; then
			echo " --> Checking HEX '$sig': Match found, applying patch..."
			hex_dump=$(echo "$hex_dump" | sed -E "s/$sig_regex/$patch/")
			patched=true
		else
			echo " --> Checking HEX '$sig': Not found. Skipped."
		fi
	done

	if [ "$patched" = true ]; then
		echo "$hex_dump" | xxd -r -p > "lib_patched/$library"
		echo; echo " --> ✅ SUCCESS: Patch applied successfully. File saved to lib_patched/$library"
		echo
	else
		echo; echo " --> ⚠️ WARNING: No patch changes were made to the file."
		echo
	fi
	
	rm -rf tmp