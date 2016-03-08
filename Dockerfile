FROM java:8
ARG ES_TAR_NAME=logstash-2.2.2
ARG ES_TAR_URL=https://download.elastic.co/logstash/logstash/
EXPOSE 9200
EXPOSE 9300

# Create directory
RUN mkdir /home/local
WORKDIR /home/local

# Download
RUN wget ${ES_TAR_URL}${ES_TAR_NAME}.tar.gz && \
    tar --strip-components 1 -xvf ${ES_TAR_NAME}.tar.gz && \
    rm ${ES_TAR_NAME}.tar.gz

# Install plugins
RUN ./bin/plugin install logstash-input-kinesis && \
    ./bin/plugin install logstash-output-elasticsearch

# Add files
ADD worker.rb ./vendor/bundle/jruby/1.9/gems/logstash-input-kinesis-1.4.3-java/lib/logstash/inputs/kinesis/
ADD ls-aws-cwl.conf ./
ADD aws-log-init.sh ./

# Create user and assign permission
#ENTRYPOINT ["/home/local/aws-log-init.sh"]