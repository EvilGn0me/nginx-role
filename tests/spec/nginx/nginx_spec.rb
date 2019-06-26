require 'rspec'
require 'serverspec'
require 'yaml'

set :backend, :exec
conf = YAML.load_file('../defaults/main.yml')
sys = YAML.load_file('../vars/redhat.yml')

port = '80'
nginx_user = conf['nginx_conf']['user']
nginx_conf = '/etc/nginx/nginx.conf'
mime_types = '/etc/nginx/mime.types'
pidfile = conf['nginx_conf']['pidfile']
confdir = sys['nginx']['conf_dir']
services = sys['nginx']['services']

describe port(port) do
  it { should be_listening }
end

describe file(pidfile) do
  it { should exist }
end

describe file(confdir) do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by nginx_user }
end

describe file(confdir + 'localhost.conf') do
  it { should exist }
  its(:content) { should match /Ansible/ }
  its(:content) { should match /stub_status/ }
  it { should be_owned_by nginx_user }
end

describe file(confdir + 'test.conf') do
  it { should exist }
  its(:content) { should match /Ansible/ }
  its(:content) { should match /test.example.com/ }
  its(:content) { should match /stub_status/ }
  it { should be_owned_by nginx_user }
end

describe file(nginx_conf) do
  it { should exist }
  its(:content) { should match /Ansible/ }
  it { should be_owned_by nginx_user }
end

describe file(mime_types) do
  it { should exist }
  its(:content) { should match /Ansible/ }
  it { should be_owned_by nginx_user }
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
