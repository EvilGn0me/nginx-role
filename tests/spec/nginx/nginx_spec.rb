require 'rspec'
require 'serverspec'
require 'yaml'

set :backend, :exec
conf = YAML.load_file('../defaults/main.yml')
sys = YAML.load_file('../vars/redhat.yml')

port = '80'
services = sys["nginx"]["services"]

describe port(port) do
  it { should be_listening }
end

services.each do |service|
  describe service(service), :if => os[:family] == 'redhat' do
      it { should be_enabled }
      it { should be_running }
  end
end

describe user('nginx') do
  it { should have_login_shell conf["nginx_conf"]["user_shell"]}
end
