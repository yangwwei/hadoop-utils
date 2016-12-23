#!/usr/bin/python

import json
import urllib2
import socket
import sys
from datetime import datetime

def get_heap_usage(logfile='/tmp/nm_heap_metrics.log'):
    current_host=socket.gethostname()
    jvm_url='http://{0}:8042/jmx?qry=Hadoop:service=NodeManager,name=JvmMetrics'.format(current_host)
    now=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print now + " - Query REST API :" + jvm_url

    jvm_jsons=json.load(urllib2.urlopen(jvm_url))
    jvm_json=jvm_jsons['beans'][0]

    MemHeapUsedM=jvm_json['MemHeapUsedM']
    MemHeapCommittedM=jvm_json['MemHeapCommittedM']
    MemHeapMaxM=jvm_json['MemHeapMaxM']

    print "*** Node Manager Heap Metrics ***"
    print 'MemHeapUsedM={0}'.format(MemHeapUsedM)
    print 'MemHeapCommittedM={0}'.format(MemHeapCommittedM)
    print 'MemHeapMaxM={0}'.format(MemHeapMaxM)

    log = open(logfile, 'a')
    log.write('{0},{1},{2},{3}\n'.format(now, MemHeapUsedM, MemHeapCommittedM, MemHeapMaxM))
    log.close()


def get_container_nums(logfile='/tmp/nm_container_metrics.log'):
    current_host=socket.gethostname()
    container_url='http://{0}:8042/jmx?qry=Hadoop:service=NodeManager,name=NodeManagerMetrics'.format(current_host)
    now=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print now + " - Query REST API :" + container_url
    container_json=json.load(urllib2.urlopen(container_url))['beans'][0]

    ContainersLaunched=container_json['ContainersLaunched']
    ContainersCompleted=container_json['ContainersCompleted']
    ContainersFailed=container_json['ContainersFailed']
    ContainersKilled=container_json['ContainersKilled']

    print "*** Node Manager Container Metrics ***"
    print 'ContainersLaunched={0}'.format(ContainersLaunched)
    print 'ContainersCompleted={0}'.format(ContainersCompleted)
    print 'ContainersFailed={0}'.format(ContainersFailed)
    print 'ContainersKilled={0}'.format(ContainersKilled)

    log = open(logfile, 'a')
    log.write('{0},{1},{2},{3},{4}\n'.format(now, ContainersLaunched, ContainersCompleted, ContainersFailed, ContainersKilled))
    log.close()

if __name__ == "__main__":
    metricslog=sys.argv[1]
    containerlog=sys.argv[2]
    get_heap_usage(logfile=metricslog)
    get_container_nums(logfile=containerlog)
