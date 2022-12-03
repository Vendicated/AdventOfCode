function Get-Priority {
  param (
    [string]$char
  )

  if ([char]$char -ge [char]"a") {
    return 1 + [char]$char - [char]"a"
  } else {
    return 27 + [char]$char - [char]"A"
  }
}

foreach ($file in $args) {
  $sum = 0
  $currentGroupRucksacks = @()
  $groupSum = 0
  :OuterLoop
  foreach ($line in Get-Content $file) {
    if ($currentGroupRucksacks.Count -eq 2) {
      for ($i = 0; $i -lt $line.Length; $i++) {
        if (
          $currentGroupRucksacks[0] -cmatch $line[$i] -and
          $currentGroupRucksacks[1] -cmatch $line[$i]
        ) {
          $groupSum += Get-Priority $line[$i]
          break;
        }
      }
      $currentGroupRucksacks = @()
    } else {
      $currentGroupRucksacks += $line
    }

    $compartmentSize = $line.Length / 2
    for ($i = 0; $i -lt $compartmentSize; $i++) {
      for ($j = $compartmentSize; $j -lt $line.Length; $j++) {
        if ($line[$i] -ceq $line[$j]) {
          $sum += Get-Priority $line[$i]
          continue OuterLoop
        }
      }
    }
  }

  Write-Output "${file} Part 1: $sum"
  Write-Output "${file} Part 2: $groupSum"
}
