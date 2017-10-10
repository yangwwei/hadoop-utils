from=${1}
to=${2}
for host in `cat hosts`;
do
  echo ">> Copying ${from} to ${host}"
  scp ${from} ${host}:${to}
  if [ $? -ne 0 ]; then
    echo ">execution failed, exiting..."
    exit 1
  fi
done
