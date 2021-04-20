from ubuntu:20.04
maintainer root@recolic.net

run apt update && apt install -y fish wget curl git
run wget https://git.recolic.net/root/json2table/uploads/63b923b53a191968f0dc29cd988d7b4f/json2table-linux-static -O /usr/bin/json2table && chmod +x /usr/bin/json2table

run mkdir -p /app
copy . /app
workdir /app

cmd "./gitlab2github_daemon.fish"



