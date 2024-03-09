Written by @duhansysl

All rights reserved, you can NOT use the codes in this script without my permissions. Its only for commercial use.

Big thanks to @3arthur6 who did the TWRP patches for it. I got the right HEX values from his project.
His TWRP patcher is here : https://github.com/3arthur6/BluetoothLibraryPatcher

And @PeterKnecht93 who helped me in this project. 

 
* You can run this on Terminal with WSL2 or Linux 
* You need to choose the right OneUI version to make it work "properly". Every android has its own HEX values so if you don't choose the right value it will fail or won't patch properly for sure.
* OneUI 1/2/3/4 needs "libbluetooth.so", take it from lib64 folder and put it in "in" folder
* OneUI 5/6 needs either "libbluetooth_jni.so" or "com.android.btservices.apex" so get them from your ROM base and add them into "in" folder
* Patched lib will be copied to "lib_patched" folder and stock one will be copied to "lib_stock" folder. 

* Last updated: 09.03.2024 - 22:01
