#-*- encoding: utf-8 -*-

"""
DNSimple state
requires:
https://github.com/KristianOellegaard/dnsimple-api/tree/updated-dnsimple-api
"""

import json
import logging
import requests as req


log = logging.getLogger(__name__)

COMMON_HEADER = {'Accept':'application/json',
                 'Content-Type': 'application/json',
                 }
TOKEN = 'NF1IS6a4w7WFGoTjV5bb'

def auth_session(email, token):
    ses = req.Session()
    ses.auth = (email, token)
    ses.headers.update(COMMON_HEADER)
    ses.headers.update({'X-DNSimple-Token': email + ":" + token})
    return ses

BASE_URL = 'https://dnsimple.com'


def _is_available(domain, email, token):
    path = '/domains/%s/check' % domain
    ses = auth_session(email, token)
    resp = ses.get(BASE_URL + path)
    if resp.status_code == 200:
        return False
    elif resp.status_code == 404:
        # 404 mean domain do not exist => avail
        return True
    else:
        raise Exception("{0} {1} {2} {3}".format(BASE_URL,
                        path, resp.status_code, resp.content))

def created(name, email, token):
    domain = name
    ret = {'name': domain,
            'changes': {},
            'result': False,
            'comment': ''}

    path = "/domains"
    ses = auth_session(email, token)
    data = {"domain": {"name": domain}}
    resp = ses.post(BASE_URL + path, json.dumps(data))
    log.info("{0} {1}".format(resp.status_code, resp.content))
    if resp.status_code == 201:
        ret['result'] = True
        ret['changes']['{0}'.format(domain)] = "Created in your account"
    elif resp.status_code == 400:
        comment = "already in your account."
        if comment in resp.content:
            ret['result'] = True
            ret['comment'] = "{0}".format(comment)
    elif resp.status_code == 401:
        ret['result'] = False
    else:
        raise Exception("{0} {1}".format(resp.status_code, resp.content))
    return ret

def existed(domain, email, token, record):
    ret = {'name': 'existed',
            'changes': {},
            'result': False,
            'comment': ''}

    path = "/domains/{0}/records".format(domain)
    ses = auth_session(email, token)
    data = {"record": {"name": record.get('name', ''),
                       "record_type": record.get('record_type'),
                       "content": record.get('content'),
                       "ttl": record.get('ttl', 3600),
                       "prio": record.get('prio', 10),}
           }

    resp = ses.post(BASE_URL + path, json.dumps(data))
    if resp.status_code == 201:
        ret['changes'][record.get('content')] = "created"
        ret['result'] = True
    elif resp.status_code == 422:
        comment = 'already exists'
        if comment in resp.content:
            ret['comment'] = comment
            ret['result'] = True
    elif resp.status_code == 400:
        ret['result'] = False
        ret['comment'] = "{0}".format(resp.content)
    else:
        raise Exception("{0} {1}".format(resp.status_code, resp.content))
    return ret

def records_exists(domain, email, token, records):
    conn = DNSimple(email, token)
    dom = Domain(conn, {"name": domain})
    for rectype in records:
        for name in records[rectype]:
            dom.add_record(name, rectype.upper(), records[rectype][name]['content'])

    return {'name': 'records_exists',
            'changes': {},
            'result': True,
            'comment': ''}

if __name__ == "__main__":
    EMAIL = "hvnsweeting@gmail.com"
    domain = 'hwngxxy.info'
    print created(domain, EMAIL, TOKEN)
    record = { "name": "", 
            "record_type": "MX",
            "content": "mail.hwngxxy.info",
            #"ttl": 3600, 
            #"prio": 10 
            }

    print existed(domain, EMAIL, TOKEN, record)
