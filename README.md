# Samsung Galaxy Book2 Pro 360 (950QED) Audio Speaker Fix for Linux

This repository provides a definitive fix for the internal speakers on the **Samsung Galaxy Book2 Pro 360 (model 950QED)** running Ubuntu or other Debian-based Linux distributions.

## The Problem
On this specific model, the audio driver loads correctly and sound works perfectly through the 3.5mm headphone jack. However, the internal speakers remain silent. This is due to a secondary speaker amplifier chip (likely a Cirrus Logic model) that is not correctly initialized by the standard SOF (Sound Open Firmware) driver.

## The Solution
This project uses a script (`realtek-alc298-amp-init.sh`) containing a sequence of `hda-verb` commands. These commands were captured from the Windows driver and manually force the initialization of the speaker amplifiers.

An installation script (`install.sh`) automates the process by:
1.  Copying the initialization script to a system directory.
2.  Creating and enabling a `systemd` service to run the script automatically at boot and after resuming from suspend.

## Prerequisites
Before running the installer, you must ensure two things are in place:

**1. The Sound Card is Detected:**
The SOF driver must load correctly. On this model, it requires a kernel parameter.
-   Edit your GRUB configuration: `sudo nano /etc/default/grub`
-   Find the line `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`
-   Add the parameter `snd_hda_intel.dmic_acpi_check=0` to the end, inside the quotes:
    `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash snd_hda_intel.dmic_acpi_check=0"`
-   Save the file, then run `sudo update-grub` and reboot.
-   Verify that audio works with wired headphones before proceeding.

**2. `hda-verb` is Installed:**
The script depends on this tool, which is part of the `alsa-tools` package.
```bash
sudo apt update
sudo apt install alsa-tools
