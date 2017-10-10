cmd=$@
for host in `cat hosts`;
do
  echo ">> Running command ${cmd} on ${host}"
  ssh ${host} ${cmd}
  if [ $? -ne 0 ]; then
    echo ">execution failed, exiting..."
    exit 1
  fi
done
