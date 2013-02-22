mit-scheme:
    file.managed:
        - name: /usr/local/src/mit-scheme.tar.gz
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
        - name: tar xzf /usr/local/src/mit-scheme.tar.gz -C /tmp
        - unless: test -d /tmp/mit-scheme-9.1.1
        - require:
            - file: mit-scheme

install:
    cmd.run:
        - name: ./configure && make compile-microcode && make install
        - cwd: /tmp/mit-scheme-9.1.1/src/ 
        - require:
            - pkg: buildtools
            - cmd: untar
        - unless: 'which mit-scheme'
