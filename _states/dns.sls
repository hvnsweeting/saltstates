{% set mymail = 'YOUREMAIL' %}
{% set mytoken = 'YOURTOKEN' %}

"hwng.info":
  dnsi:
    - created
    - email: {{ mymail }}
    - token: {{ mytoken }}

"abdhwng.info":
  dnsi:
    - created
    - email: {{ mymail }}
    - token: {{ mytoken }}


records:
  dnsi:
    - existed
    - domain: "hwng.info"
    - email: {{ mymail }}
    - token: {{ mytoken }}
    - record:
        name: ""
        record_type: MX
        content: abc.hwng.info
