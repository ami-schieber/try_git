import jenkins

server = jenkins.Jenkins('http://10.12.205.25', username='ami.schieber', password='Chen-280800!')
user = server.get_whoami()
version = server.get_version()
print('Hello %s from Jenkins %s' % (user['fullName'], version))
