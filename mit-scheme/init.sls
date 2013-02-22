mit-scheme:
    file.managed:
        - name: /tmp/mit-scheme.tar.gz
    {% if grains['cpuarch'] == 'x86_64' %}
        - source: http://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.1.1/mit-scheme-9.1.1-x86-64.tar.gz
        - source_hash: md5=268cb5ac97646f34742828ebc370586d
    {% else %}
        - source: http://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.1.1/mit-scheme-9.1.1-i386.tar.gz
        - source_hash: md5=e35590a06549d71edba723a719329070
    {% endif %}

    
buildtools:
    pkg.installed:
        - pkgs: 
            - build-essential
            - m4

untar:
    cmd.run:
        - name: 'cd /tmp && tar xzf /tmp/mit-scheme.tar.gz'
        - unless: test -d /tmp/mit-scheme-9.1.1


configure:
    cmd.run:
        - name: 'cd /tmp/mit-scheme-9.1.1/src/ && ./configure'
        - require:
            - file: mit-scheme
            - pkg: buildtools
            - cmd: untar

cd /tmp/mit-scheme-9.1.1/src && make compile-microcode && make install:
    cmd.run:
        - require:
            - cmd: configure
        - unless: 'which mit-scheme'
            
