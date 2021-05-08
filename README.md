# gitlab2github

This tool pull all public repo of some users FROM gitlab TO github. 

Gitlab is the actual dev repo, and github is a mirror. 

Dependencies: fish, json2table, git

This doesn't recursively resolve gitlab sub-group. Please specify every sub-group as a new namespace. 

## Usage

```
sudo docker build -f Dockerfile -t recolic/gitlab2github .
sudo docker run -d --restart=always --name rgitsync --env github_user_dst="rtestgithubapi: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" recolic/gitlab2github
```

## Disable sync for specific repo

run `echo sync=0 > .gitlab2github.conf` in the master or default branch, and push it. 

