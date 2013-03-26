openjdk-7-jdk:
  pkg:
    - installed

sbt_installing:
  file:
    - managed
    - name: /usr/local/src/sbt.tgz
    - source: http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.2/sbt.tgz 
    - source_hash: md5=85d152809397cb01a2dfc5c43657be3c
  cmd:
    - run
    - name: tar xzf /usr/local/src/sbt.tgz -C /usr/local
    - unless: test -e /usr/local/sbt
  
/usr/bin/sbt:
  file:
    - symlink
    - target: /usr/local/sbt/bin/sbt
    - require:
      - cmd: sbt_installing
