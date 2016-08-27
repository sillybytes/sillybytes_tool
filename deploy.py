#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
from googleapiclient import discovery
from oauth2client import client
from oauth2client import file
from oauth2client import tools
import sys
import os
import httplib2
import argparse

SILLYBYTESID="1318550761233559867"

def main(argv):
    if (len(argv) < 2):
        print("Post title must be provided as argument")
        exit(1)

    scope = 'https://www.googleapis.com/auth/blogger'
    client_secrets = os.path.join(os.path.dirname(__file__),
                                  'client_secrets.json')

    flow = client.flow_from_clientsecrets(client_secrets,
                                        scope=scope,
                                        message=tools.message_if_missing(client_secrets))

    storage = file.Storage('blogger' + '.dat')
    credentials = storage.get()
    if credentials is None or credentials.invalid:
        credentials = tools.run_flow(flow, storage, flags)

    http = credentials.authorize(http = httplib2.Http())
    service = discovery.build('blogger', 'v3', http=http)

    posts = service.posts()

    body = {
        "kind": "blogger#post",
        "title": "test post",
        "content": "<h1>test post</h1>"
    }

    print( argv[1] )
    request = posts.insert(blogId=SILLYBYTESID, body=body, isDraft=True)
    # result = request.execute()
    # print(result)

if __name__ == '__main__':
    main(sys.argv)
