if [ $# -eq 0 ]
  then
    echo "🛑 First arguments must be server name!"
    exit
fi

if [ ! -z "`git status | grep "not staged"`" ]; then
   echo "🛑 You have not staged changes. Make 'git add .' "
   exit
fi

if [ ! -z "`git status | grep "to be committed"`" ]; then
   echo "🛑 You forgot to make 'git commit'"
   exit
fi

if [ ! -z "`git status | grep "is ahead"`" ]; then
   echo "🛑 You have not pushed changes. Make 'git push' "
   exit
fi

echo "✅ Begin uploading upp to server: '$1'"

REPO=`git remote -v | head -n 1 | awk '{print $2}'`
APP_NAME=`echo $REPO | grep -oE "/[a-z-]+" - | cut -c2-`

echo "Using repository '$REPO' and application '$APP_NAME'"

if ssh $1 rm remote_run.sh; then
    echo "✅ Script remote_run.sh deleted from server!"
    else
      echo "File remote_run.sh does not contained on server"
  fi

if ! scp ./production/remote_run.sh $1:~/remote_run.sh; then
  echo "🛑 Copy remote_run.sh failed"
  exit;
  fi

echo "✅ Script remote_run.sh copied!"

if ! ssh $1 "./remote_run.sh $APP_NAME $REPO"; then
  echo "🛑 Failed while running remote_run.sh"
  exit 1;
fi

echo "✅ Done! "