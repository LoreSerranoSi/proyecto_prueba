FROM openjdk:11

LABEL maintainer="loreserrasilve1690@gmail.com"

ENV  PYSPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
ENV  SPARK_HOME=/opt/spark
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV  PATH="$SPARK_HOME/bin:$JAVA_HOME/bin:$PATH"

#  Instala  dependencias  del sistema
RUN  apt-get  update &&  \
       apt-get  install -y  wget  curl  ca-certificates python3  python3-pip  procps  openjdk-11-jdk &&  \
       update-ca-certificates  && \
       pip3  install  --upgrade pip

#  Descarga e  instala  Apache  Spark
RUN  curl  --insecure  -L -o  spark.tgz  https://archive.apache.org/dist/spark/spark-${PYSPARK_VERSION}/spark-${PYSPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz  && \
       tar  -xzf  spark.tgz -C  /opt/  &&  \
      mv  /opt/spark-${PYSPARK_VERSION}-bin-hadoop${HADOOP_VERSION}  /opt/spark  && \
       rm  spark.tgz

#  Descarga  automáticamente  el driver  JDBC  de  PostgreSQL
RUN  mkdir  -p  /opt/spark/jars &&  \
    curl --insecure -L -o  /opt/spark/jars/postgresql-42.7.3.jar  https://jdbc.postgresql.org/download/postgresql-42.7.3.jar

WORKDIR  /app

# Instala  dependencias  de  Python
COPY  requirements.txt  ./
RUN pip3  install  -r  requirements.txt

#  Copia  el script  principal
COPY  ejemplo.py ./

#  Ejecuta el  script  con  Spark y  el  driver  JDBC
CMD  ["spark-submit",  "--jars",  "/opt/spark/jars/postgresql-42.7.3.jar", "ejemplo.py"]