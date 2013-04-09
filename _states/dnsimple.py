#-*- encoding: utf-8 -*-

"""
DNSimple state
requires: requests==1.2.0
"""

import json
import logging
try:
    import requests
except ImportError:
    requests = None


log = logging.getLogger(__name__)

COMMON_HEADER = {'Accept':'application/json',
                 'Content-Type': 'application/json',
                 }
TOKEN = 'em3BJZR7xyokvKNlF9f'

def auth_session(email, token):
    ses = requests.Session()
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

def existed(domain, email, token, nrecord):
    ret = {'name': 'existed',
            'changes': {},
            'result': False,
            'comment': ''}

    path = "/domains/{0}/records".format(domain)
    ses = auth_session(email, token)
    data = {"record": {"name": nrecord.get('name', ''),
                       "record_type": nrecord.get('record_type'),
                       "content": nrecord.get('content'),
                       "ttl": nrecord.get('ttl', 3600),
                       "prio": nrecord.get('prio', 10),}
           }

    resp = ses.post(BASE_URL + path, json.dumps(data))
    print resp.status_code, resp.content
    if resp.status_code == 201:
        ret['changes'][nrecord.get('content')] = "created"
        ret['result'] = True
    elif resp.status_code == 422:
        comment = 'already exists'
        getresp = ses.get(BASE_URL + path)
        recs = json.loads(getresp.content)
        recs = [i['record'] for i in recs]
        for rec in recs:
            if rec['name'] == nrecord['name'] and rec['content'] == nrecord['content']:
                path = "/domains/{0}/records/{1}".format(domain, rec['id'])
                putresp = ses.put(BASE_URL + path, data=json.dumps(data))
                print putresp.status_code, putresp.content
                break
        if comment in resp.content:
            ret['comment'] = comment
            ret['result'] = True
    elif resp.status_code == 400:
        ret['result'] = False
        ret['comment'] = "{0}".format(resp.content)
    elif resp.status_code == 404:
        if "Couldn\'t find Domain with name" in resp.content:
            ret['result'] = False
            ret['comment'] = "Couldn't find domain {0}".format(domain)
    else:
        ret['result'] = False
        ret['comment'] = "{0} {1}".format(resp.status_code, resp.content)
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
