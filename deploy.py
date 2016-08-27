#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
from oauth2client import client
from googleapiclient import sample_tools
import sys

SILLYBYTESID="1318550761233559867"

def main(argv):
    service, flags = sample_tools.init(
        argv, 'blogger', 'v3', __doc__, __file__,
        scope='https://www.googleapis.com/auth/blogger')

    posts = service.posts()

    body = {
        "kind": "blogger#post",
        "title": "test post",
        "content": "<h1>test post</h1>"
    }

    request = posts.insert(blogId=SILLYBYTESID, body=body, isDraft=True)
    result = request.execute()
    print(result)

if __name__ == '__main__':
    main(sys.argv)
