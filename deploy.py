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
    if (len(argv) < 3):
        print("Post title must be provided as the first argument and html file as the second")
        exit(1)

    post_title = argv[1]
    input_file = argv[2]

    scope = 'https://www.googleapis.com/auth/blogger'

    parent_parsers = [tools.argparser]
    parent_parsers.extend([])
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        parents=parent_parsers)
    flags = parser.parse_args("")

    try:
        client_secrets = os.path.join(os.path.expanduser("~") + '/.sillybytes/',
                                    'secrets.json')
    except:
        print("Can't find secrets.json file maybe?")
        exit(1)

    flow = client.flow_from_clientsecrets(client_secrets,
                                        scope=scope,
                                        message=tools.message_if_missing(client_secrets))

    storage = file.Storage('auth_data' + '.dat')
    credentials = storage.get()
    if credentials is None or credentials.invalid:
        credentials = tools.run_flow(flow, storage, flags)

    http = credentials.authorize(http = httplib2.Http())
    service = discovery.build('blogger', 'v3', http=http)

    try:
        content = open(input_file, 'r').read()
    except FileNotFoundError:
        print("Input file not found")
        exit(1)

    body = {
        "kind": "blogger#post",
        "title": post_title,
        "content": content
    }

    try:
        posts = service.posts()
        request = posts.insert(blogId=SILLYBYTESID, body=body, isDraft=False)
        result = request.execute()
        print("Live: " + result['url'])
    except:
        print("Can't execute request")
        exit(1)

if __name__ == '__main__':
    main(sys.argv)
