#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "including-files"]{Including Files}

The standard maps include shared files for the resource generation.

@itemlist[
 @item{In AoC/UP this is found within the gamedata_x1.drs file.  You can open the drs file with any text editor and look for the relevant part.}
 @item{In vanilla HD you can find the land_resources.inc file in the gamedata_x1 folder.}
 @item{In DE you can find the GeneratingObjects.inc file in the gamedata_x2 folder.  Additionally you can find shared files for seasons, elevation, animals, water mixing, etc.}
 ]

The file random_map.def is always included, without having to specify it.  It contains all the predefined constants.

@bold{VERY IMPORTANT:  Included rms files are NOT transferred in the lobby!  This means:}

@itemlist[
 @item{You CAN include any of the standard files that are part of the game, because other players will already have them in their directory.}
 @item{You CANNOT include custom files, unless everyone in the lobby has the file.  So you can include custom files with full conversion mods, because all players will need to have the mod to be able to play in the first place.}
 ]

@defproc[(%include-drs [path any/c]) void?]{
 Game versions: HD/DE (in AoC it is used for the built-in maps, but doesn't seem to work for custom maps)

 Arguments:
 path - name (or path and name)

 Valid file extensions are: rms, rms2, inc, def

 You can navigate to a parent directory with "../".

 @seclink["including-files"]{Include a file} located in the gamedata folder.

 If you include a file somewhere else, the file path must be relative to the gamedata folder.

 Example: Include the DE seasons file, so that you can use it in your own script, without having to set up your own terrains.
 @racketmod[
 aoe2-rms

 (%include-drs "F_seasons.inc")
 ]

 Example: Include that classic land and water resources file from AoC.
 @racketmod[
 aoe2-rms

 (%include-drs "land_and_water_resources.inc")
 ]

 Example: Make a custom version of blind random.
 @racketmod[
 aoe2-rms

 (%random [20 (%include-drs "Arabia.rms")]
          [20 (%include-drs "Baltic.rms")]
          [20 (%include-drs "Gold_Rush.rms")]
          [20 (%include-drs "Islands.rms")]
          [20 (%include-drs "Team_Islands.rms")])
 ]
}

@defproc[(%include-xs [path any/c]) void?]{
 Game versions: DE only

 External reference: @hyperlink["https://www.forgottenempires.net/age-of-empires-ii-definitive-edition/xs-scripting-in-age-of-empires-ii-definitive-edition"]{.xs scripting in Age of Empires II: Definitive Edition}, @hyperlink["https://ugc.aoe2.rocks/general/xs/"]{XS Scripting For Beginners}

 Arguments:
 path - name (or path and name)

 @itemlist[
 @item{Valid file extensions are: xs}
 @item{You can navigate to a parent directory with ../}
 @item{BUG:  You cannot surround your path with quotation marks}
 ]

 @seclink["including-files"]{Include an xs file}, located in the xs folder.

 @itemlist[
 @item{If you include a file somewhere else, the file path must be relative to the xs folder.}
 @item{The path can also be relative to the xs folder in player profile, rather than to the xs folder in the main game directory.}
 @item{Unlike included rms files, included XS files DO transfer automatically to players and spectators.}
 ]

 Example:
 @racketmod[
 aoe2-rms

 (%include-xs "file.xs")
 ]
}
