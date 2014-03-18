#!/usr/bin/python

import sys
from datetime import date, timedelta

if len(sys.argv) < 2:
    sys.exit("You're doing it wrong!")

futuredate = date.today() + timedelta(days=int(sys.argv[1]))
print (futuredate.strftime("%b %d"))
