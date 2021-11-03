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

if [ -z "`history | grep 'apt-get update'`"  ]
then
  sudo apt-get update -y
  sudo apt-get upgrade -y
fi

if [ -z "`history | grep 'apt install -y docker-compose'`"  ]
then
  sudo apt install -y docker
  sudo apt install -y docker-compose
fi

if [ -z "`history | grep 'sudo apt install -y git'`"  ]
then
  sudo apt install -y git
fi

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

if test -f "run.sh"; then
    echo "🏃 Using run.sh"
else
  echo "🏃 Run docker compose"
  docker-compose build
  docker-compose up -d
fi

