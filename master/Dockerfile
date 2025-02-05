# Base Image
FROM ubuntu:22.04


# Set root password
RUN echo "root:root" | chpasswd

# Update and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openjdk-8-jdk wget ssh openssh-server vim sudo iputils-ping && \
    apt-get clean

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_HOME=/home/hadoopnamhy/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin

# Configure SSH
RUN ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd

# Create user hadoopnamhy
RUN adduser --disabled-password --gecos "" hadoopnamhy && \
    echo "hadoopnamhy:hadoopnamhy" | chpasswd && \
    usermod -aG sudo hadoopnamhy && \
    echo "hadoopnamhy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Hadoop
USER hadoopnamhy
WORKDIR /home/hadoopnamhy
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz && \
    tar -xzf hadoop-3.4.1.tar.gz && \
    mv hadoop-3.4.1 hadoop && \
    rm hadoop-3.4.1.tar.gz

# Set JAVA_HOME in hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> /home/hadoopnamhy/hadoop/etc/hadoop/hadoop-env.sh

# Configure bashrc
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_HOME=/home/hadoopnamhy/hadoop" >> /home/hadoopnamhy/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/bin" >> /home/hadoopnamhy/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/sbin" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_YARN_HOME=\$HADOOP_HOME" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> /home/hadoopnamhy/.bashrc && \
    echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> /home/hadoopnamhy/.bashrc
    

# Copy Hadoop configuration files
COPY config/core-site.xml /home/hadoopnamhy/hadoop/etc/hadoop/core-site.xml
COPY config/hdfs-site.xml /home/hadoopnamhy/hadoop/etc/hadoop/hdfs-site.xml
COPY config/mapred-site.xml /home/hadoopnamhy/hadoop/etc/hadoop/mapred-site.xml
COPY config/yarn-site.xml /home/hadoopnamhy/hadoop/etc/hadoop/yarn-site.xml
COPY config/workers /home/hadoopnamhy/hadoop/etc/hadoop/workers

# Configure SSH keys
RUN mkdir -p /home/hadoopnamhy/.ssh && \
    ssh-keygen -t rsa -f /home/hadoopnamhy/.ssh/id_rsa -P "" && \
    cat /home/hadoopnamhy/.ssh/id_rsa.pub >> /home/hadoopnamhy/.ssh/authorized_keys && \
    chmod 600 /home/hadoopnamhy/.ssh/authorized_keys && \
    chown -R hadoopnamhy:hadoopnamhy /home/hadoopnamhy/.ssh


# Format HDFS
RUN hdfs namenode -format

# Expose ports
EXPOSE 22 50070 8088 9000

USER root
# Start SSH and Hadoop services
CMD ["/bin/bash", "-c", "service ssh start && su - hadoopnamhy && bash"]
