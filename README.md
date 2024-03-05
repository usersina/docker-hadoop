# Hadoop Docker

## Pre-requisites

- GNU Make `>= 4` (or manually copy the commands from the `Makefile` recipes)

## Quick Start

To deploy an example HDFS cluster, run:

```bash
docker-compose up
```

Run example wordcount job:

```bash
make wordcount
```

Access the hadoop interfaces with the following URLs:

- Namenode: <http://localhost:9870/dfshealth.html#tab-overview>
- History server: <http://localhost:8188/applicationhistory>
- Datanode: <http://localhost:9864/>
- Nodemanager: <http://localhost:8042/node>
- Resource manager: <http://localhost:8088/>

## Manual run

You can open a shell with direct access to hadoop as follows

```bash
make shell
```

In the opened shell, you can directly communicate with HDFS. Here's an example

```bash
# Copy the file to HDFS (already there)
# hadoop fs -copyFromLocal /opt/hadoop-3.3.6/README.txt /input/
hadoop fs -ls /input/

# Delete the output directory (if any)
hadoop fs -rm -r /output
rm -rf /mydata/output

# Run the wordcount job
hadoop jar /mydata/WordCount.jar WordCount /input /output

# Copy the output to local
hadoop fs -copyToLocal /output /mydata/output
```

## Configure Environment Variables

The configuration parameters can be specified in the hadoop.env file or as environmental variables for specific services (e.g. namenode, datanode etc.):

```conf
CORE_CONF_fs_defaultFS=hdfs://namenode:8020
```

CORE_CONF corresponds to core-site.xml. fs_defaultFS=hdfs://namenode:8020 will be transformed into:

```xml
<property><name>fs.defaultFS</name><value>hdfs://namenode:8020</value></property>
```

To define dash inside a configuration parameter, use triple underscore, such as YARN*CONF_yarn_log\*\*\_aggregation*\*\*enable=true (yarn-site.xml):

```xml
<property><name>yarn.log-aggregation-enable</name><value>true</value></property>
```

The available configurations are:

- /etc/hadoop/core-site.xml CORE_CONF
- /etc/hadoop/hdfs-site.xml HDFS_CONF
- /etc/hadoop/yarn-site.xml YARN_CONF
- /etc/hadoop/httpfs-site.xml HTTPFS_CONF
- /etc/hadoop/kms-site.xml KMS_CONF
- /etc/hadoop/mapred-site.xml MAPRED_CONF

If you need to extend some other [configuration](https://hadoop.apache.org/docs/r3.2.4/hadoop-project-dist/hadoop-common/ClusterSetup.html) file, refer to base/entrypoint.sh bash script.
