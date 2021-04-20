#!/usr/bin/fish

set gitlab_host https://git.recolic.net
# set gitlab_namespace_src users/root groups/recolic-hust
set gitlab_namespace_src users/root
set github_user_dst "rtestgithubapi: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"

function echo2
    echo $argv 1>&2
end

function sync_one_project
    set project_name $argv[1]
    set project_url $argv[2]
    set github_project_desc "This is a read-only mirror for $project_url"
    echo2 "Syncing $project_url to github:$github_user_dst..."

    # Prepare github repository
    set resp (curl -s -u $github_user_dst --data "{\"name\":\"$project_name\", \"description\":\"$github_project_desc\"}" https://api.github.com/user/repos)
    if echo $resp | grep -F "name already exists on this account"
        # Good. Update existing repo
    else if echo $resp | grep -F $github_project_desc
        echo2 "Creating new github repository success: $project_name"
    else
        echo2 "Failed to create or update github repo: $resp"
        return 2
    end
    set github_username (echo $github_user_dst | sed 's/:.*$//g')
    set github_project_url "https://$github_user_dst@github.com/$github_username/$project_name.git"

    # Do the sync
    test -d $project_name
        or begin
            git clone $project_url $project_name
            and cd $project_name
            and git remote add dst $github_project_url
            and cd ..
            or return 3
        end

    cd $project_name
        # https://stackoverflow.com/questions/67054889/force-git-pull-to-resolve-divergent-by-discard-all-local-commits
        and git fetch
        and git reset --hard "@{upstream}"
        and git push --tags --force dst (git branch --show-current)
        and cd ..
        or return 4
end

function do_namespace_copy
    set ns_src $argv[1]
    echo2 "Processing gitlab namespace $ns_src..."
    set project_list (curl -s "$gitlab_host/api/v4/$ns_src/projects?per_page=9999" | json2table http_url_to_repo -p | grep VAL: | sed 's/^VAL: //g' | sed 's/|//g')
    set workdir (pwd) # to avoid some failure in sync_one_project changes the workdir. 
    for project_url in $project_list
        set project_name (echo "$project_url" | sed 's/.git$//g' | sed 's/^.*\///g')
        sync_one_project $project_name $project_url
            or echo2 "sync_one_project fails for $project_name with status=$status"
        sleep 10
    end
end

for ns in $gitlab_namespace_src
    do_namespace_copy $ns
end







