require 'rspec'
require 'serverspec'
require 'yaml'

set :backend, :exec
conf = YAML.load_file('../defaults/main.yml')
sys = YAML.load_file('../vars/redhat.yml')

port = '80'
nginx_conf = '/etc/nginx/nginx.conf'
mime_types = '/etc/nginx/mime.types'
confdir = sys['nginx']['conf_dir']
services = sys['nginx']['services']

describe port(port) do
  it { should be_listening }
end

describe file(confdir) do
  it { should exist }
  it { should be_directory }
end

describe file(confdir + 'localhost.conf') do
  it { should exist }
  its(:content) { should match /Ansible/ }
  its(:content) { should match /stub_status/ }
end

describe file(confdir + 'test.conf') do
  it { should exist }
  its(:content) { should match /Ansible/ }
  its(:content) { should match /test.example.com/ }
  its(:content) { should match /stub_status/ }
end

describe file(nginx_conf) do
  it { should exist }
  its(:content) { should match /Ansible/ }
end

describe file(mime_types) do
  it { should exist }
  its(:content) { should match /Ansible/ }
end

services.each do |service|
  describe service(service), :if => os[:family] == 'redhat' do
      it { should be_enabled }
      it { should be_running }
  end
end

describe user('nginx') do
  it { should have_login_shell conf['nginx_conf']['user_shell']}
end
