
function liste_dir {
    param([string]$path        # chemin à examiner
        ,[int]$niveau = 0      # profondeur du chemin en cours
        ,[int]$max_prev = 0    # prévision maxi
        )

    $sub_dirs = Get-ChildItem $path -Directory
    $nb_sub_dir = $sub_dirs.Count

    if ($nb_sub_dir -eq 0) {
        # Write-Host $indent $path "pas de sous dossiers"
        return 0
    }

    $i = 1
    $tot_sub_dir = 0

    foreach ($dir in $sub_dirs) {
        $max = [math]::max($tot_sub_dir, $prev_sub_dir)
        $nb = liste_dir $dir.FullName ($niveau + 1) $max
        $tot_sub_dir += $nb
        $prev_sub_dir = [math]::max($tot_sub_dir / $i * $nb_sub_dir, $max_prev)
        $i++
        
        $bar_status = ("tot = {0}  prev = {1}" -f $tot_sub_dir, $prev_sub_dir)
        write-progress -id $bar_id -activity $bar_title -status $bar_status `
            -percentcomplete $($tot_sub_dir * 100 / $max)
    }

    $tot_sub_dir += $nb_sub_dir

    # Write-Host $indent $path $tot_sub_dir "sous dossiers" 
    return $tot_sub_dir
}

$bar_id = 10
$bar_title = "scan"
$bar_status = "Lancement du scan..."

write-progress -id $bar_id -activity $bar_title -status $bar_status -percentcomplete $(1)

liste_dir "\\srv-cffic\users\cfinbj\mes documents\" 

write-progress -id $id -activity $bar_title -Completed