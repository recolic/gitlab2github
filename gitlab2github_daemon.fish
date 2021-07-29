#!/usr/bin/fish

while true
    # git.recolic.net and gitsync located on the same machine. If the machine is rebooted, this script will fail and retry again and again. 
    # sleep 60 to avoid deadly crazy retry loop
    sleep 60

    fish ./gitlab2github_sync.fish
    echo "Sleeping 3600s..." 1>&2
    sleep 3600
end

