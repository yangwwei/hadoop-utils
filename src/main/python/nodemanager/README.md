# Collect Node Manager Metrics

Query Node Manager rest api on current node, collect jvm and container metrics, append them into two log files.
* total_times_to_run (required) : How many times this script runs
* time_interval (required) : The time interval in seconds to run this script
* log_path_for_jvm_metrics (optional, default /tmp/nm_heap_metrics.log) : Log file to store JVM metrics
* log_path_for_container_metrics (optional, default /tmp/nm_container_metrics.log) : Log file to store container metrics

```
python trace_nm_metrics.py
  [total_times_to_run]
  [time_interval]
  [log_path_for_jvm_metrics]
  [log_path_for_container_metrics]
```

For example

Run script for 300 times in 5 seconds interval, output will be written to /tmp/1.log and /tmp/2.log.

```
python trace_nm_metrics.py 300 5 /tmp/1.log /tmp/2.log
```
