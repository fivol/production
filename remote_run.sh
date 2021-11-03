# Run this script on remote server to prepare it to use

if [ $# -eq 0 ]
  then
    echo "First arguments must be app name"
    exit 1
fi

if [ -z $HOSTNAME ]
  then
    echo "It seems, you run script on your local machine"
    exit 1
fi

# TODO Make only on new servers (add auto check)
sudo apt-get update -y
sudo apt-get upgrade -y

# TODO Optimize (not install if exists)
sudo apt install -y docker
# TODO Fix docker-compose unsupported version problem
sudo apt install -y docker-compose
sudo apt install -y git
# https://stackoverflow.com/questions/43671482/how-to-run-docker-compose-up-d-at-system-start-up
sudo systemctl enable docker

if ! cd $1; then
  git clone $2
  git submodule update --init
  cd $1
else
  git pull
  git submodule update --recursive
fi

docker-compose build
docker-compose up -d
