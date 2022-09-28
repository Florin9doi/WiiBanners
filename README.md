## Rules:
* Wii only
* No custom banners

## How to

#### Submit Banners on Windows (git)
1. Clone the repo: `git clone https://github.com/Florin9doi/WiiBanners.git`
2. Run `BackupBanners.ps1 "<Wii NAND Root>" <Git>` with PowerShell
3. Submit a pull request

#### Submit Banners on Windows (zip)
1. Download [BackupBanners.ps1](https://github.com/Florin9doi/WiiBanners/raw/master/BackupBanners.ps1)
2. Run `BackupBanners.ps1 "<Wii NAND Root>" <Zip>` with PowerShell
3. Create a new issue and attach the archive

#### Submit Banners on macOS (git)
1. Clone the repo: `git clone https://github.com/Florin9doi/WiiBanners.git ~/WiiBanners`
2. Run `rsync -avzPR ~/Library/Application\ Support/Dolphin/Wii/title/./*/*/*/banner.bin ~/WiiBanners/Wii/title/` in a terminal.
3. Submit a pull request

#### Submit Banners on macOS (zip)
1. Run `cd ~/Library/Application\ Support/Dolphin/`
2. Run `find Wii/title -name 'banner.bin' | zip ~/Downloads/WiiBanners-$(date +%s).zip -@`
3. Open a new issue and attach `~/Downloads/WiiBanners-*.zip` archive.

#### Generate PNG Images
1. Install required Python module `pip install pypng`
2. Run `find "$(pwd -P)" -name 'banner.bin' -exec python3 BinToPng.py "{}" "{}.png" \;`.
3. The `banner.bin.png` images will be found next to its `banner.bin` files.

#### Restore
1. Download the [repo](https://github.com/Florin9doi/WiiBanners/zipball/master)
2. Copy the files to your Wii NAND Root
