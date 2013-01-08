# 
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright 2012, Wil Schultz
#

include_recipe "git::default"

admin_name	= node["gitolite"]["admin_name"]
admin_home	= node["gitolite"]["admin_home"]
install_dir	= node["gitolite"]["install_dir"]
repository_url	= node["gitolite"]["repository_url"]

githost = node['hostname']


user "#{admin_name}" do
  comment "Gitolite Admin User"
  shell "/bin/bash"
  home "#{admin_home}"
  supports :manage_home => true
end

directory "#{install_dir}" do
  user "#{admin_name}"
  group "#{admin_name}"
  mode 00755
  action :create
  recursive true
end

git "#{install_dir}" do
  repository "#{repository_url}"
  reference "master"
  action :checkout
  user "#{admin_name}"
  group "#{admin_name}"
end

execute "ssh-keygen -q -f #{admin_home}/.ssh/id_rsa -N \"\"" do
  user "#{admin_name}"
  group "#{admin_name}"
  action :run
  creates "#{admin_home}/.ssh/id_rsa.pub"
end

directory "#{install_dir}/bin" do
  user "#{admin_name}"
  group "#{admin_name}"
  mode 00755
  action :create
  recursive true
end

execute "./install -ln" do
  user "#{admin_name}"
  group "#{admin_name}"
  environment ({"HOME" => "#{install_dir}"})
  cwd "#{install_dir}"
  creates "#{install_dir}/bin/gitolite"
end

execute "bin/gitolite setup -pk #{admin_home}/.ssh/id_rsa.pub" do
  user "#{admin_name}"
  group "#{admin_name}"
  environment ({"HOME" => "#{admin_home}", "USER" => "#{admin_name}"})
  cwd "#{install_dir}"
  creates "#{admin_home}/.ssh/authorized_keys"
end

execute "echo 'StrictHostKeyChecking no' > #{admin_home}/.ssh/config" do
  user "#{admin_name}"
  group "#{admin_name}"
  environment ({"HOME" => "#{admin_home}", "USER" => "#{admin_name}"})
  cwd "#{admin_home}"
  creates "#{admin_home}/.ssh/config"
end

# This doesn't work as expected... supplimented with an exec below.
#git "#{admin_home}/gitolite-admin" do
#  repository "git@#{githost}:gitolite-admin"
#  reference "master"
#  action :sync
#  remote "origin"
#  user "#{admin_name}"
#  group "#{admin_name}"
#end

execute "git clone git@#{githost}:gitolite-admin" do
  user "#{admin_name}"
  group "#{admin_name}"
  cwd "#{admin_home}"
  creates "#{admin_home}/gitolite-admin"
end

