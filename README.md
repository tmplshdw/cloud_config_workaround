# cloud_config_workaround
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
* DEATH STRANDING DIRECTOR'S CUT
* Pinball M

Please create a new issue for other games that also need a workaround

## To use:

### Linux/Steam Deck

Download the script somewhere and make sure it's set as executable.

Add the launch option to the relevant game

`/path/to/download/cloud_config_workaround.sh %command%`


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
