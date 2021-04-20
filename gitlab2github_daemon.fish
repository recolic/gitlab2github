#!/usr/bin/fish

while true
    fish ./gitlab2github_sync.fish
    echo "Sleeping 3600s..." 1>&2
    sleep 3600
end

