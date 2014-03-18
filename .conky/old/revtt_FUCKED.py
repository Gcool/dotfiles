#!/usr/bin/python2

# displays RevolutionTT Top 10 torrents in conky

# script by karabaja4
# karabaja4@archlinux.us

# to get proper output in conky run this script like this:
# ${execpi 120 python2 ~/scripts/revtt/revtt.py --uid <uid> --pass <pass>}

import os
import sys
import subprocess
import argparse #requires python2-argparse (AUR)
from HTMLParser import HTMLParser

# html parser
class MyHTMLParser(HTMLParser):

	def __init__(self):
		HTMLParser.__init__(self)
		self.recording = 0 
		self.data = []
  
	def handle_starttag(self, tag, attrs):
		if tag == 'table':
			for name, value in attrs:
				if name == 'id' and value == 'torrents-top10-table':
					self.recording = 1 


	def handle_endtag(self, tag):
		if tag == 'table' and self.recording:
			self.recording -=1

	def handle_data(self, data):
		if self.recording:
			self.data.append(data)

# cookie builder
def makeCookie(uid, pw):
	f = open("cookie.txt", "w")
	f.write("www.revolutiontt.net\tFALSE\t/\tFALSE\t9999999999\tuid\t%s\n" % uid)
	f.write("www.revolutiontt.net\tFALSE\t/\tFALSE\t9999999999\tpass\t%s" % pw)
	f.close()

# page fetcher
def getBrowsePage():
	fh = open(os.devnull,"w")
	proc = subprocess.Popen("wget --load-cookies=cookie.txt https://www.revolutiontt.net/browse.php", stdout = fh, stderr = fh, shell=True)
	sts = os.waitpid(proc.pid, 0)[1]
	fh.close()

# main program
def main():
	
	# parse arguments
	parser = argparse.ArgumentParser()
	parser.add_argument('--uid', dest='uid', help='[required] set user uid', required=True)
	parser.add_argument('--pass', dest='pw', help='[required] set pass hash', required=True)
	parser._optionals.title = "arguments"
	options = parser.parse_args()

	# change the path to working dir
	os.chdir(os.path.dirname(sys.argv[0]))
	
	# cleanup garbage
	if os.path.isfile("browse.php"): os.remove("browse.php")
	if os.path.isfile("cookie.txt"): os.remove("cookie.txt")

	# make the cookie
	makeCookie(options.uid, options.pw)

	# fetch the page using the cookie
	getBrowsePage()

	# load the page
	f = open("browse.php", "r")
	html = f.read()
	f.close()

	# parse the page
	p = MyHTMLParser()
	p.feed(html)

	# the torrent names are on exactly these data locations
	# hackish but it's freakin parsed html, what do you expect

	topTen = []
	topTen.append(p.data[1])  #1
	topTen.append(p.data[7])  #2
	topTen.append(p.data[13]) #3
	topTen.append(p.data[19]) #4
	topTen.append(p.data[25]) #5
	topTen.append(p.data[31]) #6
	topTen.append(p.data[37]) #7
	topTen.append(p.data[43]) #8
	topTen.append(p.data[49]) #9
	topTen.append(p.data[55]) #10

	p.close()
	os.remove("browse.php")
	os.remove("cookie.txt")

	for (i, line) in enumerate(topTen):
		
		#shorten the lines
		if len(line) > 50: line = line[:50] + "..."
		
		############# optional for highlighting favorite torrents #############
		
		# House and TBBT
		if 'house'  in line.lower(): line = "${color1}" + line + "${color}"
		if 'theory' in line.lower(): line = "${color1}" + line + "${color}"
		
		#######################################################################
		
		count = str(i + 1)
		if (i == 9): count = "X"
		
		# enumerate and the line
		line = "${color2}" + count + ". " + "${color}${color3}" + line + "${color}"
		
		print line
		
main()