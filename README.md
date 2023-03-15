# youtubeMusicMixScript
Script which downloads audio from Youtube, and creates video with looped video.

What this README covers:
- [Installation guide](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#installation-guide)
- [Quick start](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#quick-start)
- [How (and why) it works?](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#how-and-why-it-works)
- [FAQ](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#faq)
- [Credentials](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#credentials)

# Installation guide
This installation guide will be split in 2 parts:
1. [Script installation](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#script-installation)
2. [Addon installation](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#addon-installation)

## Script installation
1. Download this repo by clicking `Code` -> `Download ZIP`   
![obraz](https://user-images.githubusercontent.com/25950627/225444258-ca005cfb-5376-4b52-8418-4e06f0bbd84b.png)   
or cloning it by `git clone git@github.com:GrzegorzWalewski/youtubeMusicMixScript.git`
2. If You downloaded ZIP file, then unzip it
3. Right click on `install.bat` and `run as administrator`
4. Wait untill You see `DONE`, click any button to close cmd

## Addon installation
You can skip this part if You only want to manually run script, but I think using and addon is way more cooler :D
1. We need to install `Youtube Enhancer` addon:
  - FIREFOX - [download](https://addons.mozilla.org/en-US/firefox/addon/enhancer-for-youtube/)
  - chrome/opera/edge - [download](https://chrome.google.com/webstore/detail/enhancer-for-youtube/ponfpcnoihfmfllpaingbgckeeldkhle)
2. After installation go to config page by left clicking this button   
![obraz](https://user-images.githubusercontent.com/25950627/225442322-48d7e404-5bf4-4221-8060-a1aa23058f96.png)
3. On config page check this   
![obraz](https://user-images.githubusercontent.com/25950627/225442524-601a65c3-2c62-4ddb-8903-83911341091a.png)
4. Slide down to `Custom script` section
5. Paste:
```
var url = window.location.href;
var name = document.querySelectorAll('h1.ytd-watch-metadata')[0].innerText;
var videoSample = prompt('ID  Description\n--------------------------\n1  #  "motivation | training | outdoor"\n2  #  "car | drift | phonk"\n3  #  "DJ | disco | techno"\n4  #  "DJ | techno | mixer"\n5  #  "city in night | mood"\n6  #  "party | people dancing"\n7  #  "DJ | mixer | people dancing in background"\n8  #  "endless loop"\n9  #  "fireplace | dark | mood aesthetic"\n10 #  "disco ball | girl standing and moving it"\n11 #  "endless rain loop"\n12 #  "pomp up | training | gym"\n13 #  "drift | car"\n14 #  "dancing | flowers | girl"\n15 #  "flowers | aesthetic | old film"\n16 #  "dark | red | girl standing | slow cam"\n17 #  "sad | dark | slow cam"\n18 #  "party | one person dancing"\n19 #  "party | people\'s faces | pills"\n20 #  "gaming"\n21 #  "gaming keyboard"\n--------------------------\nPlease enter video sample number:', "1");
 console.log(url, name, videoSample);
url = url.replaceAll('&', 'and');
name = name.replaceAll('&', 'and');
videoSample = videoSample.replaceAll('&', 'and');
var wholeAppUrl='myuri://example.com/path?' + name.toLowerCase().replace(/[^a-zA-Z0-9]+/g, "-") + '&' + videoSample.toLowerCase().replace(/[^a-zA-Z0-9]+/g, "-") + '&' + url;
window.open(wholeAppUrl, '_blank')
```
6. Click Save - `Automatically execute the script when YouTube is loaded in a tab` should **NOT** be checked

# Quick start
If You installed addon in [Addon installation](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#addon-installation) step continue reading from [Quick start with addon](https://github.com/GrzegorzWalewski/youtubeMusicMixScript/edit/master/README.md#using-with-addon), else continue reading from here.
## Using script manually
1. Navigate to `Program files\grzojda\libraries` dir
2. Double click on `allInOne.bat`
3. You will be asked for readyToUpload dir path   
![obraz](https://user-images.githubusercontent.com/25950627/225443695-f9a313cd-e40c-442a-9486-983022a93d6a.png)   
For example: `C:\Users\Grzojda\Desktop\music\readyToUpload`
4. Next insert Youtube link
5. Choose sample video that should be use as a loop in video
6. Enter final file name (without extension)
## Using with Addon
1. Go to any Youtube video You wish
2. Click on `Custom script` icon under video![obraz](https://user-images.githubusercontent.com/25950627/225439689-f01670d2-d50d-4221-bbab-5454ea241743.png)
3. cmd should open
4. You will be asked for readyToUpload dir path   
![obraz](https://user-images.githubusercontent.com/25950627/225443695-f9a313cd-e40c-442a-9486-983022a93d6a.png)   
For example: `C:\Users\Grzojda\Desktop\music\readyToUpload`

# How (and why) it works?
...

# FAQ
1. What if I want to change the readyToUpload dir later?
- Delete `last_dir.txt` file
# Credentials
I'm using few libraries to get it work:
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [ffmpeg](https://github.com/BtbN/FFmpeg-Builds)
- [Enhancer for Youtube](https://www.mrfdev.com/enhancer-for-youtube)
