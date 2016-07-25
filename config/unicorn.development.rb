# Ansible managed: /Users/Limix/Documents/Projects/in-spiritus/railsbox/ansible/roles/unicorn/templates/unicorn.rb.j2 modified on 2016-07-24 15:33:28 by Limix on Arams-MacBook-Pro.local

working_directory '/in-spiritus'

pid '/tmp/in-spiritus/unicorn.development.pid'

stderr_path '/in-spiritus/log/unicorn.err.log'
stdout_path '/in-spiritus/log/unicorn.log'

listen '/tmp/unicorn.development.sock'

worker_processes 2

timeout 30
