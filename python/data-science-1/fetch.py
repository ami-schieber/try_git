# requests for fetching html of website
import requests

# Make the request to a url
r = requests.get('http://www.cleveland.com/metro/index.ssf/2017/12/case_western_reserve_university_president_barbara_snyders_base_salary_and_bonus_pay_tops_among_private_colleges_in_ohio.html')

# Create soup from content of request
c = r.content

from bs4 import BeautifulSoup

soup = BeautifulSoup(c)

# Find the element on the webpage
main_content = soup.find('div', attrs = {'class': 'entry-content'})
main_content

# Extract the relevant information
content = main_content.find('ul').text

import pprint
pprint.pprint(content)

import re

# Create a pattern to match names
name_pattern = re.compile(r'^([A-Z]{1}.+?)(?:,)', flags = re.M)
name_pattern.findall(content)

names = name_pattern.findall(content)

# Remind ourselves what our soup looks like
pprint.pprint(content)

# Make school patttern and examine results
school_pattern = re.compile(r'(?:,|,\s)([A-Z]{1}.*?)(?:\s\(|:|,)')
school_pattern.findall(content)

# Extract the schools
schools = school_pattern.findall(content)

# Pattern to match the salaries
salary_pattern = re.compile(r'\$.+')
salary_pattern.findall(content)
pprint.pprint(content)

# Messy salary
salary = '$876,001'

# Exclude the $ and split the string on the comma
salary[1:].split(',')

# Same operation but now join the list with no space
''.join(salary[1:].split(','))

# Finally convert the string to a float
float(''.join(salary[1:].split(',')))

# Messy salaries
salaries = ['$876,001', '$543,903', '$2453,896']

# Convert salaries to numbers using the above procedure in a list comprehension 
[int(''.join(s[1:].split(','))) for s in salaries]

# Extract all the salaries and convert to integers
salaries = salary_pattern.findall(content)

# List comprehension to convert strings to floats
salaries = [int(''.join(s[1:].split(','))) for s in salaries]

salaries

# Sanity check to make sure everything is correct!
len(names) == len(schools) == len(salaries)
