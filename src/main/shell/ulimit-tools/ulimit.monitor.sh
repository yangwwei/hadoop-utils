#####
## Set a reasonable threshold to monitor
NOFILE_THRESHOLD=150000
#####
#####
## Sleep interval, default 1 minute
#####
SLEEP_INTERVAL=60
#####
## Logs go to /tmp/ulimit-monitor-xxx/ dir
#####
TMP_DIR=/tmp/ulimit-monitor-`date +%s`/


rm -rf ${TMP_DIR}
mkdir -p ${TMP_DIR}
if [ $? -ne 0 ]; then
  echo "** Please check permission of the temp dir ${TMP_DIR}"
  exit 1
fi
echo "****************************************************************************"
echo "*** Script launched to monitor number of open files for hdfs and yarn users"
echo "*** NOFILE_THRESHOLD=${NOFILE_THRESHOLD}"
echo "*** SLEEP_INTERVAL=${SLEEP_INTERVAL}"
echo "*** Logs are writtent to ${TMP_DIR}"
echo "****************************************************************************"
#####
## At most run 1 week, 1 minutes interval
#####
for (( i=1; i<10080; i++ ))
do
  echo "***** Ulimit monitor #${i} *****"
  NOFILE_HDFS=`lsof -u hdfs | wc -l`
  NOFILE_YARN=`lsof -u yarn | wc -l`

  echo "* Number of open files (hdfs) : ${NOFILE_HDFS}"
  echo "* Number of open files (yarn) : ${NOFILE_YARN}"
  echo ""

  LOG_PROCESS=0
  if [ ${NOFILE_HDFS} -gt ${NOFILE_THRESHOLD} ]; then
    NOFILE_LIST_HDFS=${TMP_DIR}/nofile_hdfs.${i}.out
    rm -rf ${NOFILE_LIST}
    echo "* (hdfs) Number of open file exceeds the threshold, logging the open file list to ${NOFILE_LIST_HDFS}"
    lsof -u hdfs > ${NOFILE_LIST_HDFS}
    echo ""
    LOG_PROCESS=1
  fi

  if [ ${NOFILE_YARN} -gt ${NOFILE_THRESHOLD} ]; then
    NOFILE_LIST_YARN=${TMP_DIR}/nofile_yarn.${i}.out
    rm -rf ${NOFILE_LIST_YARN}
    echo "* (yarn) Number of open file exceeds the threshold, logging the open file list to ${NOFILE_LIST_YARN}"
    lsof -u hdfs > ${NOFILE_LIST_YARN}
    echo ""
    LOG_PROCESS=1
  fi

  if [ ${LOG_PROCESS} -eq 1 ]; then
    PROC_LIST=${TMP_DIR}/proc.${i}.out
    rm -rf ${PROC_LIST}
    echo "* Logging processes info to ${PROC_LIST}"
    ps aux > ${PROC_LIST}
  fi
  echo "* sleep 5 minutes"
  sleep ${SLEEP_INTERVAL}
  echo ""
done
