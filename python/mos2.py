import crc16
import json
import hashlib
import urllib2

def get_md5_hash(s):
 	md5 = hashlib.md5()
 	md5.update(s)
 	return md5.hexdigest()

def get_default_index_size():
 	to_find = '87d41d15f'
 	md5_hash = get_md5_hash('logo.png')
 	index = md5_hash.index(to_find)
 	return index, index + len(to_find)

def get_file_url(name, show_name=1):
 	start, end = get_default_index_size()
 	md5_hash = get_md5_hash(name)
 	return "http://130.211.84.170/challenge1/get-image?name=%s&h=%s&multiple=%d" % (name, md5_hash[start:end], show_name)

def get_list_of_all_files():
 	res = urllib2.urlopen(get_file_url('*'))
 	res_text = res.read()
 	return json.loads(res_text)

def get_file(name):
 	file_url = get_file_url(name, show_name=0)
 	res = urllib2.urlopen(file_url)
 	return res.read()


if __name__ == '__main__':
	all_files = get_list_of_all_files()
 	for f in all_files:
 		f_data = get_file(f)
 		print f, hex(crc16.crc16xmodem(f_data))
 		with open(f, 'wb') as fb:
 			fb.write(f_data)
 			fb.flush()
