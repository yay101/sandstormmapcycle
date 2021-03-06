
param(
[array]$mode,
[array]$lighting,
[array]$options,
[array]$side
)

$Allmodes= "
Checkpoint
Domination
Firefight East
Firefight West
Frontline
Outpost
Push
Skirmish
Team Deathmatch
"

$maplist = @(
[pscustomobject]@{name='Crossing';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Frontline','Outpost','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Farmhouse';mode='Checkpoint Insurgents','Checkpoint Security','Firefight East','Domination','Firefight West','Frontline','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Hideout';mode='Checkpoint Insurgents','Checkpoint Security','Firefight East','Domination','Firefight West','Frontline','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Hillside';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Frontline','Outpost','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Ministry';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Outpost','Skirmish','Team Deathmatch';lighting='Night,Day'}
[pscustomobject]@{name='Outskirts';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Firefight East','Frontline','Outpost','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='PowerPlant';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Firefight East','Outpost','Push Insurgents','Push Security';lighting='Night','Day'}
[pscustomobject]@{name='Precinct';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Firefight East','Frontline','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Refinery';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Frontline','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Summit';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Firefight East','Frontline','Push Insurgents','Push Security','Skirmish','Team Deathmatch';lighting='Night','Day'}
[pscustomobject]@{name='Tell';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Firefight East','Outpost','Push Insurgents','Push Security','Frontline';lighting='Night','Day'}
[pscustomobject]@{name='Tideway';mode='Checkpoint Insurgents','Checkpoint Security','Domination','Firefight West','Frontline','Push Insurgents','Push Security';lighting='Night','Day'}
)

$dict = @{
    'Firefight East' = "Firefight_East"
    'Firefight West' = "Firefight_West"
    'Checkpoint Insurgents' = "Checkpoint_Insurgents"
    'Checkpoint Security' = "Checkpoint_Security"
    'Push Insurgents' = "Push_Insurgents"
    'Push Security' = "Push_Security"
    'Team Deathmatch' = "Team_Deathmatch"
}

function go($mode,$lighting,$options,$side){
if($mode -eq "Checkpoint" -or $mode -eq "Push"){
$mode = $mode + " " + $side
}
$filtered = $maplist | where-object {$_.mode -contains $mode -and $_.lighting -contains $lighting}
foreach ($map in $filtered){
if($dict.$mode){
$mode = $dict.($mode)
}
$matched = "(Scenario=`"Scenario_" + $map.name + "_" + $mode + "`"" + $options + ",Lighting=" + "`"" + $lighting + "`")`n"
$export += $matched
}
Return $Export
}

function genlist($mode,$lighting,$options,$side){
foreach ($style in $mode){
foreach ($time in $lighting){
if(!($side)){
	go $style $time $options
}
foreach ($team in $side){
$time
$team
	go $style $time $options $team
}
}
}
$Export
}

if($mode){
[array]$mode = $mode.Split(",")
if($options){
$options = ",Options=`"Mutators=" + $options + "`""
}
if(!($lighting)){
[array]$Lighting = @('Night','Day')
}
if($mode -contains "Checkpoint" -or $mode -contains "Push" -and -not $side){
Write-Host "No side selected generating for both."
[array]$Side = @('Insurgents','Security')
}
genlist $mode $lighting $options $side
} else {
Write-Host "USAGE:
./Maplist.ps1 Checkpoint Day Insurgents
./Maplist.ps1 Push
./Maplist.ps1 -mode Domination -options SlowMovement
Maps:
$($Maplist.name)

Modes:
$Allmodes
"
}