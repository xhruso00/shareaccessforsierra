# Share Access for Sierra
Simple utility that should save you some time. Instead of going to online iCloud Drive you can edit file share options from menu. For menu option, app needs to be in /Application folder

[Download](https://github.com/xhruso00/shareaccessforsierra/raw/master/ShareAccessForSierra.dmg)

Remeber to register with Terminal using command "pluginkit -e use -i com.hrubasko.Share-Access-for-Sierra"

### Discussion 

Native Share support in Finder is only available on High Sierra but the API came with Sierra. Unfortunatelly it is bit buggy (NSRemoteView crashing) but still usable. Everyone can access iCloud Drive sharing options from browser. 

Due to bug in implementation, there are some options for unshared file. File that has been already shared works.

Please open an issue if you find a bug that can be fixed.

If someone knows how to get native share support in Sierra please answer [here](https://apple.stackexchange.com/questions/306157/icloud-drive-sharing-on-sierra-add-people)

# Application window
![](https://raw.githubusercontent.com/xhruso00/shareaccessforsierra/master/appWindow.png)

# Menu

![](https://raw.githubusercontent.com/xhruso00/shareaccessforsierra/master/Menu.png)

## TODO
Extract duplicated files (2 targets) into one framework that is shared by targets.
