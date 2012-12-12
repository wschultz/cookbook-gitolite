#
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright 2012, Wil Schultz
#

include_recipe "git::default"
githost = node['hostname']

user "#{node[:gitolite][:admin_name]}" do
  comment "Gitolite Admin User"
  shell "/bin/bash"
  home "#{node[:gitolite][:admin_home]}"
  supports :manage_home => true
end

directory "#{node[:gitolite][:install_dir]}" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  mode 00755
  action :create
  recursive true
end

git "#{node[:gitolite][:install_dir]}" do
  repository "#{node[:gitolite][:repository_url]}"
  reference "master"
  action :checkout
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
end

execute "ssh-keygen -q -f #{node[:gitolite][:admin_home]}/.ssh/id_rsa -N \"\"" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  action :run
  creates "#{node[:gitolite][:admin_home]}/.ssh/id_rsa.pub"
end

directory "#{node[:gitolite][:install_dir]}/bin" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  mode 00755
  action :create
  recursive true
end

execute "./install -ln" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  environment ({"HOME" => "#{node[:gitolite][:install_dir]}"})
  cwd "#{node[:gitolite][:install_dir]}"
  creates "#{node[:gitolite][:install_dir]}/bin/gitolite"
end

execute "bin/gitolite setup -pk #{node[:gitolite][:admin_home]}/.ssh/id_rsa.pub" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  environment ({"HOME" => "#{node[:gitolite][:admin_home]}", "USER" => "#{node[:gitolite][:admin_name]}"})
  cwd "#{node[:gitolite][:install_dir]}"
  creates "#{node[:gitolite][:admin_home]}/.ssh/authorized_keys"
end

execute "echo 'StrictHostKeyChecking no' > #{node[:gitolite][:admin_home]}/.ssh/config" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  environment ({"HOME" => "#{node[:gitolite][:admin_home]}", "USER" => "#{node[:gitolite][:admin_name]}"})
  cwd "#{node[:gitolite][:admin_home]}"
  creates "#{node[:gitolite][:admin_home]}/.ssh/config"
end

# This doesn't work as expected... supplimented with an exec below.
#git "#{node[:gitolite][:admin_home]}/gitolite-admin" do
#  repository "git@#{githost}:gitolite-admin"
#  reference "master"
#  action :sync
#  remote "origin"
#  user "#{node[:gitolite][:admin_name]}"
#  group "#{node[:gitolite][:admin_name]}"
#end

execute "git clone git@#{githost}:gitolite-admin" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  cwd "#{node[:gitolite][:admin_home]}"
  creates "#{node[:gitolite][:admin_home]}/gitolite-admin"
end

