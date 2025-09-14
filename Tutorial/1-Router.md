# DomuPi Tutorial – Private Router with Captive Portal

This guide walks through setting up DomuPi as a **private router**.  
You’ll connect your Pi to a public or private Wi-Fi (wlan0), and then rebroadcast it through a USB Wi-Fi dongle (wlan1) as your own secure hotspot.

---

## What You’ll Need

### Hardware
- **Raspberry Pi 5** (Pi 4 works too, 4GB of ram or more if you plan to use it as more than just a router)  
- **An active cooling module** (this part is not superintensive but given the 24/7 aspect of the project, its a must-have)
- **MicroSD card** (32 GB or larger, Make sure its a beefy longlasting one as you will be running the device possibly 24/7)  
- **Official Raspberry Pi power supply** (I dont recommend messing around with third party options)  
- **USB Wi-Fi dongle** (tested: TP-Link TX20U / AX1800, you can use any as long as it specifically notes **LINUX-COMPATIBLE**)  
- **Optional:** Ethernet cable, Display and peripherals, compatible case for raspberry

### Software
- **Raspberry Pi OS (Bookworm, 64-bit)**  
- **RaspAP** (auto-installed via script)  
- **SSH client** (PowerShell on Windows, or built-in Terminal on Linux/macOS)  
- **RealVNC viewer**
  


## Step 1 – Flashing Raspberry Pi OS to the SD card

You’ll need to prepare a bootable SD card with Raspberry Pi OS before starting.


 First grab the Raspberry Pi Imager (download: https://www.raspberrypi.com/software/)

 **Open Raspberry Pi Imager**.  
   - Find your specific model on the "choose device" tab
   - For “Operating System” choose: Raspberry Pi OS 64-bit
   - click "choose storage" and select your microSD card (make sure you pick the right one, all data will be erased).  

3. **Advanced Settings** (click the gear icon):  
   - **Set Hostname:** `user` (this name will be used when using ssh)
   - **Enable SSH:** check this and allow password authentication.  
   - **Set Username and Password:**  
     - Username: `user`  
     - Password: *(choose something simple for now, can be changed later)*
     - setting the hostname and username as the same will make the next process less confusing
   - **Configure Wi-Fi:**  
     - Only if you want Pi to auto-connect on first boot and you dont have access to a display or Ethernet.
   - **Set Locale:** Region, keyboard, timezone (important so logs and DNS work correctly).  

4. **Write** the image and wait until it finishes.  

### First Boot
- Insert the SD card into your Pi.  
- Power it on.
- the blinking light should turn into a solid green
- after a few seconds it should automatically connect to thze desired network
- The Pi will boot with your chosen hostname (`user.local`) and SSH enabled, so you can connect from your computer without a monitor.  

---

## Step 2 – First Connection, Updates, and Installing RaspAP

Once your Pi has booted with the SD card, you’ll access it from your computer using SSH, if you are using a display directly instead, you can skip this step.
Make sure both devices are connected to the same network!
### Connect via SSH
- **Windows (PowerShell):**
  ```powershell
    ssh user@domupi.local
- **Linux or macOS (terminal)**
    ```terminal
    ssh user@domupi.local
Replace **user** with the hostname you set when flashing the SD card. Enter your password when asked (nothing will appear while typing, this is normal).
If .local does not work, check your router for the Pi’s IP address and connect with:
  ssh user@<IP address>

 ---

 ## Step 3 - Updates and installing Raspap

 its best practice to first make sure everything on your raspberry is up to date before starting so will run 
  ```linux terminal
  sudo apt update
  sudo apt full-upgrade -y
  sudo reboot
