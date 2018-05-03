# Skadoosh
## Version 2: By _Rokib Hasan Sagar_
## Transload Shallow Android Sources Just like Skadoosh...

All information available on the [XDA thread](http://forum.xda-developers.com/android/software/sources-android-sources-highly-t3231109) of the source index.

**Warning:** Do not upload your own username & password along with the repo if you modify the project!

### Usage:
At first clone This Repo into your Server and Follow the Steps
 
**IMPORTANT: Edit "compress.bash" and Replace some elements**
1. In line #11, Enter Name of the ROM. (No Spaces Please.) Example: CyanogenMod or DND, etc.
2. In line #15, Enter GitHub Manifest link. Example: https://github.com/cyanogenmod/android
3. In line #19, Enter the Branch name. Example: cm-14.1 or nougat, etc. from the Repo.
 
**For Proper uploading into MEGA, you need to add a config file besides these two scripts**

4. Create a file inside the project named "__.magarc__" (yes, no filename, only extension)
5. There should be like these 3 lines
```shell
[Login]
Username = YOUR-MEGA-NZ-EMAIL-ADDRESS
Password = YOUR-MEGA-NZ-PASSWORD
```
**GitHub Athorization** is required

6. Run these commands
```shell
git config --global user.email "YOUR-GITHUB-USER-EMAIL-ADDRESS"
git config --global user.name "YOUR-GITHUB-USERNAME"
```

**Now go inside the project where _skadoo.sh_ is located.**

Run
```shell
./compress.bash
```

### That's all
