from pyquery import PyQuery as pq
import requests

beefisms = set([])

for i in range(1, 55):
  print 'getting page %s' % i
  response = requests.get("http://www.ohnorobot.com/archive.pl?comic=636;show=2;page=%s" % i)

  content = pq(response.content)
  for td in content("td[align='left']"):
    if 'untranscribed' not in td.text:
      lines = td.text.split('/')
      for line in lines:
        if line.strip().startswith('Roast Beef:'):
          beefisms.add(line.strip()[len('Roast Beef:'):])

print beefisms

with open('beefisms.txt', 'w') as outfile:
  for line in beefisms:
    outfile.write('%s\n' % line.encode('utf-8').strip())
