# cloud config workaround
Workaround for games with graphics settings synced by Steam cloud

Currently works for:
* Witcher 3
* Sekiro
* The Secret of Monkey Island: Special Edition
* Horizon Zero Dawn
* Cult of the Lamb
* NieR:Automata
* NieR Replicant ver.1.22474487139
* Sable
* DRAGON QUEST XI S: Echoes of an Elusive Age – Definitive Edition
* Persona 5 Royal
* Klonoa Phantasy Reverie Series
* Hogwarts Legacy
* CRISIS CORE –FINAL FANTASY VII– REUNION
* DEATH STRANDING
* Pinball M
* KINGDOM HEARTS HD 1.5+2.5 ReMIX
* KINGDOM HEARTS HD 2.8 Final Chapter Prologue
* KINGDOM HEARTS III + Re Mind (DLC)
* Disco Elysium - The Final Cut
* SAND LAND

## Game not on the list?
Please create a new issue with the AppId and game name.
Include the location and name of the file that holds the configuration. When looking for the file both https://steamdb.info/ and https://www.pcgamingwiki.com can be helpful.

### How to add a game
You can add another game by adding it to the paths.txt file.

The format is:

	AppID;directory/of/config;configfilename.ext
	
Example:

	814380;%APPDATA%/Sekiro;GraphicsConfig.xml

Add one game per line and use forward slashes as path separators with Windows style path variables where needed.

If you successfully add another game please open a pull request so others can benefit.

## How to use:

### Linux/Steam Deck

Download the script somewhere and make sure it's set as executable.
Also save the paths.txt file in the same place.

Alternatively just use git:

	git clone https://github.com/tmplshdw/cloud_config_workaround.git ~/cloud_config_workaround

Add the launch option to the relevant game (change the location if you save it elsewhere)

`/home/$USER/cloud_config_workaround.sh %command%`


### Windows

Download the script somewhere

Add the launch option to the relevant game

`\path\to\download\cloud_config_workaround.bat %command%`


### If using Flatpak version of Steam:
Follow Linux/Steam Deck step and ensure you give the Steam Flatpak read/write access to your Documents folder. You may also need to provide read permissions for where you saved the cloud_config_workaround.sh script if you saved it outside your Documents folder. 
Flatseal can be used to assist with this or in the KDE Plasma settings under Personization -> Applications -> Flatpak Permission Settings.

### Multiple launch options
When you need to run multiple launch options alongside the script, only one %command% is needed at the end. Additional options may be added with a space to seperate each option
Ex.
`/path/to/download/cloud_config_workaround.sh gamemoderun %command%`
