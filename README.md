# Hadoop Docker

## Pre-requisites

- GNU Make `>= 4` (or manually copy the commands from the `Makefile` recipes)

## Quick Start

Build the local images

```bash
make
```

Download the `purchases.txt` file if not already

```bash
cd data
curl -L http://content.udacity-data.com/courses/ud617/purchases.txt.gz --output purchases.txt.gz
gzip -d purchases.txt.gz
```

To deploy an example HDFS cluster, run:

```bash
make up
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

### Base manipulation

You can open a shell with direct access to hadoop as follows

```bash
make shell
```

In the opened shell, you can directly communicate with HDFS. Here's an example

```bash
# Clean up old data (if any)
hadoop fs -rm -r /output
rm -rf /data/output

# Copy the file to HDFS
hadoop fs -mkdir /input
hadoop fs -copyFromLocal /opt/hadoop-3.3.6/README.txt /input/

# Run the wordcount job
hadoop jar /data/WordCount.jar WordCount /input /output

# Copy the output to local
hadoop fs -copyToLocal /output /data/output
```

### Mapper & Reducer Sample

This expects the [purchases file](https://chgogos.github.io/big_data/hadoop/udacity_training/) to exist at [./data/purchases.txt](data/purchases.txt).
It is not included in the repository due due to its size.

```bash
# Clean up old data (if any)
hadoop fs -rm -r /myInput
hadoop fs -rm -r /myOutput

# Create the input directory in hadoop and copy the data there
hadoop fs -mkdir /myInput
hadoop fs -put /data/purchases.txt /myInput

# Run the map/reduce job (file option is local, not in hdfs)
mapred streaming \
    -file /data/sample/mapper.py    -mapper '/usr/bin/python3 mapper.py' \
    -file /data/sample/reducer.py   -reducer '/usr/bin/python3 reducer.py' \
    -input /myInput -output /myOutput

# Copy the output to local
hadoop fs -copyToLocal /myOutput /data/output
```

## Configure Environment Variables

The configuration parameters can be specified in the hadoop.env file or as environmental variables for specific services (e.g. namenode, datanode etc.):

```conf
CORE_CONF_fs_defaultFS=hdfs://namenode:8020
```

CORE_CONF corresponds to core-site.xml. fs_defaultFS=hdfs://namenode:8020 will be transformed into:

```xml
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://namenode:8020</value>
</property>
```

To define dash inside a configuration parameter, use triple underscore, such as YARN*CONF_yarn_log\*\*\_aggregation*\*\*enable=true (yarn-site.xml):

```xml
<property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
</property>
```

The available configurations are:

- /etc/hadoop/core-site.xml CORE_CONF
- /etc/hadoop/hdfs-site.xml HDFS_CONF
- /etc/hadoop/yarn-site.xml YARN_CONF
- /etc/hadoop/httpfs-site.xml HTTPFS_CONF
- /etc/hadoop/kms-site.xml KMS_CONF
- /etc/hadoop/mapred-site.xml MAPRED_CONF

If you need to extend some other [configuration](https://hadoop.apache.org/docs/r3.2.4/hadoop-project-dist/hadoop-common/ClusterSetup.html) file, refer to base/entrypoint.sh bash script.

## Programmatic Access

You need to add the following entries to your hosts file:

- `/etc/hosts`

```shell
...

# Docker hadoop
127.0.0.1   namenode    datanode
::1         namenode    datanode
```

## Resources

- <https://github.com/big-data-europe/docker-hadoop>
- <https://github.com/big-data-europe/docker-hadoop/issues/98#issuecomment-919815981>
