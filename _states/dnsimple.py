#-*- encoding: utf-8 -*-

'''
DNSimple state
requires: requests==1.2.0
'''

import json
import logging
try:
    import requests
except ImportError:
    requests = None


log = logging.getLogger(__name__)

COMMON_HEADER = {'Accept': 'application/json',
                 'Content-Type': 'application/json',
                 }
BASE_URL = 'https://dnsimple.com'


def __virtual__():
    '''Verify requests is installed.'''
    if requests is None:
        return False
    return 'dnsimple'


def auth_session(email, token):
    ses = requests.Session()
    ses.auth = (email, token)
    ses.headers.update(COMMON_HEADER)
    ses.headers.update({'X-DNSimple-Token': email + ":" + token})
    return ses


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
        ret['changes'][domain] = "Created in your account"
    elif resp.status_code == 400:
        comment = "already in your account."
        if comment in resp.content:
            ret['result'] = True
            ret['comment'] = comment
    elif resp.status_code == 401:
        ret['result'] = False
    else:
        raise Exception("{0} {1}".format(resp.status_code, resp.content))
    return ret


def normalise(records):
    """Return a data with structure same as which returned from API"""
    ret = {}
    for domain in records:
        li = []
        for rectype in records[domain]:
            data = {}
            data['record_type'] = rectype
            recs = records[domain][rectype]
            for recname in recs:
                data['name'] = recname
                data.update(recs[recname])
            li.append(data)
        ret[domain] = li
    return ret


def records_existed(name, email, token, records):
    """
    Use returning ASAP when have any error happen. So if nothing change,
    result is true

    sls example

    records_exists:
      email:
      token:
      records:
        hwng.info:
          A:
            www:
              content: 123.11.1.11
              ttl: 123
              prio: 2
            blog:
              content: 122.2.2.2
        familug.org:
          A:
            www:
              content: 12.1.1.2
              ...
    """

    ret = {'name': 'existed',
            'changes': {},
            'result': True,
            'comment': ''}
    ses = auth_session(email, token)
    existing_records = {}
    for domain in records:
        path = "/domains/{0}/records".format(domain)
        data = json.loads(ses.get(BASE_URL + path).content)
        data = [i['record'] for i in data]
        existing_records[domain] = data

    to_update = {}
    to_create = {}
    new_records = normalise(records)
    id2erc = {}
    for domain in records:
        ex_records = existing_records[domain]
        new_domain_records = new_records[domain]
        to_update[domain] = {}
        for nrc in new_domain_records:
            need_create = True
            for erc in ex_records:
                if nrc['name'] == erc['name']:
                    id2erc[erc['id']] = erc
                    diff = {}
                    for k, v in nrc.items():
                        if erc[k] != v:
                            diff[k] = v

                    if diff != {}:
                        to_update[domain][erc['id']] = diff
                    need_create = False
                    break
            if need_create:
                if to_create == {}:
                    to_create[domain] = []
                to_create[domain].append(nrc)
    log.info("To create: {0}".format(to_create))
    log.info("To update: {0}".format(to_update))

    for domain in to_create:
        for r in to_create[domain]:
            path = "/domains/{0}/records".format(domain)
            data = {"record": r}
            resp = ses.post(BASE_URL + path, json.dumps(data))
            log.info("{0} {1}".format(resp.status_code, resp.content))
            if resp.status_code == 201:
                ret['changes']["{0}:{1}".format(domain, r['name'])] = "created"
            elif resp.status_code == 400:
                ret['result'] = False
                ret['comment'] = resp.content
                return ret
            elif resp.status_code == 404:
                if "Couldn\'t find Domain with name" in resp.content:
                    ret['result'] = False
                    ret['comment'] = "Couldn't find domain {0}".format(domain)
                    return ret
            else:
                assert resp.status_code != 422
                ret['comment'] = "{0} {1} {2}".format(domain, r,
                                                      resp.status_code)
                return ret

    for dom in to_update:
        for rid in to_update[dom]:
            path = "/domains/{0}/records/{1}".format(dom, rid)
            record_changes = to_update[dom][rid]
            resp = ses.put(BASE_URL + path,
                           json.dumps({"record": record_changes}))
            log.info("{0} {1}".format(resp.status_code, resp.content))
            if resp.status_code == 200:
                changes = []
                for k, v in record_changes.items():
                    changes.append("{0}: {1} => {2}".format(
                                   k,
                                   id2erc[rid][k],
                                   json.loads(resp.content)['record'][k]))
                ret['changes']["{0} {1}".format(dom,
                                                id2erc[rid]['name'])] = changes
            else:
                ret['result'] = False
                ret['comment'] = "{0} {1}".format(resp.status_code,
                                                  resp.content)
    return ret
