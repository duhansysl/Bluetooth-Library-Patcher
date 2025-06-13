
### Originally coded and written By @duhansysl

Big thanks to @3arthur6 who did the TWRP patches for it. I got the right HEX values from his project.
His TWRP patcher is here : https://github.com/3arthur6/BluetoothLibraryPatcher

 
### You can run this on Terminal with WSL2 or Linux in the following directory of the script by typing;

- sudo chmod +x hexpatcher.sh
- ./hexpatcher.sh

* You need to choose the right OneUI version to make it work "properly". Every android has its own HEX values so if you don't choose the right value it will fail or won't patch properly for sure.
* OneUI 1/2/3/4 needs "libbluetooth.so", take it from lib64 folder and put it in "in" folder
* OneUI 5/6/7 needs either "libbluetooth_jni.so" or "com.android.btservices.apex" so get them from your ROM base and add them into "in" folder
* Patched lib will be copied to "lib_patched" folder and stock one will be copied to "lib_stock" folder. 

### Last updated: 03.06.2025 - 23:57

### SCREENSHOTS

![script-pre](https://github.com/user-attachments/assets/af5c7e69-c30e-460a-8cf2-7ea9eb551945)

![script-after](https://github.com/user-attachments/assets/40cdef37-c0f3-40d1-99ee-5290f6e87ae8)
