# Building the image using Oracle JDK 7
FROM gelog/java:openjdk7

MAINTAINER Julien Beliveau

# Setting HBASE environment variables
ENV HBASE_VERSION 1.1.1
ENV HBASE_HOME /usr/local/hbase
ENV PATH $PATH:$HBASE_HOME/bin

# Installing wget
RUN \
    apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Installing HBase
RUN	wget https://www.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz && \
	tar -xf hbase-$HBASE_VERSION-bin.tar.gz && \
	rm hbase-$HBASE_VERSION-bin.tar.gz && \
	mv hbase-$HBASE_VERSION /usr/local/hbase
		
# Mounting the HBase data folder and exposing the ports
VOLUME /data

# 2181: zookeeper
# 8020: HDFS port
# 60000: HBase Master API port; 
# 60010 HBase Master Web UI
# 60020: HBase Regionserver API port; 
# 60030 HBase Regionserver web UI; 
# 9090 Hbase Thrift port
# 10000 hive; 
# 8888 hue; 
# 21050 Impala JDBC Port
# 8047: Drill UI
# 31010: Drill Client
# 9092: Kafka
# 7077: Spark Master Port
# 6066: Spark Rest Port
# 18080: Spark Master UI
# 18081: Spark Worker WebUI
# 18088: Spark History Server
# 4040: SparkUI
EXPOSE  2181 8020 60000 60010 60020 60030 9090 10000 8888 21050 8047 31010 9092 7077 6066 18080 18081 18088 4040 16000 16010 16020 16030 16100 



# Editing the HBase configuration file to use the local filesystem
COPY conf/hbase-site.xml  $HBASE_HOME/conf/

# Starting HBase
COPY scripts/start.sh /opt/hbase/
ENTRYPOINT ["/bin/bash", "/opt/hbase/start.sh"]
CMD []