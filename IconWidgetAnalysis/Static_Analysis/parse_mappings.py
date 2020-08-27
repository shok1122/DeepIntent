import sys
import re

file_mapping = sys.argv[1]

ifile = open(file_mapping, 'r')
ofile = open('schema_APKCalls', 'w')

ofile.write('CREATE TABLE outputmapping (Permission varchar(512) NOT NULL, Method varchar(512) NOT NULL);\n')

permission = ''
values = ''
for line in ifile:
    line = line.rstrip('\n')
    if line.startswith('Permission:'):
        if 0 < len(permission) and 0 < len(values):
            values = values[:-2]
            ofile.write('INSERT INTO outputmapping (Permission, Method) VALUES\n')
            ofile.write(values + ';')
            values = ''
        permission = line[11:]
        continue
    else:
        m = re.match(r'^<.*>', line)
        if m != None:
            method = m.group()
            values += f'  (\'{permission}\', \'{method}\'),\n'

ifile.close()
ofile.close()

