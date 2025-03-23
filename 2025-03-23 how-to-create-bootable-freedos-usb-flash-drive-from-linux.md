<!-- Description: Learn to set up a bootable FreeDOS USB for running legacy software and games, BIOS updates, or system recovery. This quick guide covers formatting, bootable media creation, and installation in simple steps. -->

tags: misc

# A Step-by-Step Guide to Creating a Bootable FreeDOS Flash Drive with a Live CD

This comprehensive guide walks you through the process of creating a bootable FreeDOS USB flash drive using a Live CD. Whether you need [FreeDOS](https://freedos.org) for running legacy software and games, BIOS updates, or troubleshooting older systems, or maybe just for fun and nostalgia. The tutorial provides clear instructions on formatting the USB drive, preparing bootable media, and ensuring successful installation. With easy-to-follow steps and essential tips, you'll be able to set up a fully functional FreeDOS environment on your flash drive in a couple of minutes.

## Step 1: Preparing the hardware

- Any flash drive... or external SSD, HDD, CD, DVD, tape, actually any data holder that you can insert into your
  computer. We will use a USB flash drive.
- Computer with a running GNU/Linux operating system with root or `sudo` access rights.
- 
## Step 2: Preparing the software

- **parted**: GNU Parted is a program for creating and manipulating partition tables.
- **unetbootin**: Software to create bootable drives from GNU/Linux with an intuitive graphical interface.

In modern desktop GNU/Linux distros, these utilities very often are included in the box; if not, then it is easy to install them:
Ubuntu/Debian

```shell
sudo apt install parted unetbootin
```

Fedora/CentOS

```shell
sudo dnf install parted unetbootin
```

Arch

```shell
pacman -S parted unetbootin
```

## Step 3: Making bootable USB Flash Drive

!!! danger
    THE PROCEDURE BELOW DESTROYS ALL DATA ON THE FLASH DRIVE, SSD, HDD, ETC. YOU HAVE BEEN WARNED!

1. Insert the USB flash drive into your computer; usually any modern GNU/Linux distribution can detect it automatically in `/dev/sdb`. Sometimes it might be `/dev/sdb1`, `/dev/sdb2`, check your USB drives carefully. In this article, we assume it is `/dev/sdb`. 
2. `sudo parted /dev/sdb mklabel freedos` command to make label "freedos".

  <blockquote>Warning: The existing disk label on /dev/sdb will be destroyed and all data on<br>
  this disk will be lost. Do you want to continue?<br>
  Yes/No? yes<br>
  New disk label type? [freedos]?<br>
  Information: Don't forget to update /etc/fstab, if necessary.</blockquote>

3.  `sudo parted /dev/sdb print` display partition table.

  <blockquote>Model: FlashDis Flash Disk (scsi)<br>
  Disk /dev/sdb: 530MB<br>
  Sector size (logical/physical): 512B/512B<br>
  Partition Table: msdos<br>
  Number Start End Size Type File system Flags<br>
  Information: Don't forget to update /etc/fstab, if necessary.</blockquote>

This means the partition table is empty.

Now create a primary partition. You need to know the size of the USB flash drive you are using:

```shell
sudo parted /dev/sdb mkpart primary fat16 0 2GB
```

Make partition bootable:

```shell
sudo parted /dev/sdb toggle 1 boot
```

## Step 4: unetbootin

1. Run `unetbootin`
2. Under **Select Distribution**, select **FreeDOS**. The **Version** will be 1.0.
3. Under **Type**, select **USB Drive**, and under **Drive**, select the partition, for example: `/dev/sdb`.
4. Once you click **OK**, unetbootin should download FreeDOS, extract and copy it to the USB flash drive.

Click **Exit**.

## Step 5: Unmount the partition


```shell
sudo umount /dev/sdb
```

Congrats! Now you have a USB drive with FreeDOS that is bootable.

*[BIOS]: Basic Input Output System
*[SSD]: Solid-State Drive
*[HDD]: Hard-Disk Drive
*[USB]: Universal Serial Bus
*[CD]: Compact Disc
*[DVD]: Digital Versatile Disc
*[GNU]: GNU Is Not Unix!