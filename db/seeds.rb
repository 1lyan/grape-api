# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
client1 = Client.create(name: 'RedLine Solutions')
client2 = Client.create(name: 'Apple')
client3 = Client.create(name: 'Huawei')

client1.projects.create(name: 'Medical Equipment', status: 'started')
client1.projects.create(name: 'Medical Database', status: 'completed')

client2.projects.create(name: 'Mac OS', status: 'started')
client2.projects.create(name: 'iOS', status: 'completed')

client3.projects.create(name: 'Phone', status: 'started')
client3.projects.create(name: 'iPad', status: 'completed')