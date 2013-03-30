message_do_not_modify = "managed file salt, manual changes might be lost"

elasticsearch:
  cluster:
    name: graylog2
    {{ grains['id'] }}: 
      private: 127.0.0.1:9300
      master: true
      data: true

