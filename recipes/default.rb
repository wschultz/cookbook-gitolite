#
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright 2012, Wil Schultz
#

include_recipe "git::default"

user "#{node[:gitolite][:admin_name]}" do
  comment "Git User"
  shell "/bin/bash"
  home "#{node[:gitolite][:admin_home]}"
  supports :manage_home => true
end

git "#{node[:gitolite][:install_dir]}" do
  repository "#{node[:gitolite][:repository_url]}"
  reference "master"
  action :sync
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
end

execute "ssh-keygen -q -f #{node[:gitolite][:admin_home]}/.ssh/id_rsa -N \"\" " do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  action :run
  not_if {File.exist? "#{node[:gitolite][:admin_home]}/.ssh/id_rsa"}
end

execute "cp #{node[:gitolite][:admin_home]}/.ssh/id_rsa.pub #{node[:gitolite][:admin_home]}/.ssh/authorized_keys" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  not_if {File.exist? "#{node[:gitolite][:admin_home]}/.ssh/authorized_keys"}
end

execute "gitolite/install -ln /usr/local/bin" do
  user "root"
  environment ({"HOME" => "#{node[:gitolite][:admin_home]}"})
  cwd "#{node[:gitolite][:admin_home]}"
  not_if {File.exists?("#{node[:gitolite][:admin_home]}/gitolite/src/VERSION") }
end

execute "gitolite setup -pk .ssh/id_rsa.pub" do
  user "#{node[:gitolite][:admin_name]}"
  group "#{node[:gitolite][:admin_name]}"
  environment ({"HOME" => "#{node[:gitolite][:admin_home]}"})
  cwd "#{node[:gitolite][:admin_home]}"
  not_if {File.exist? "#{node[:gitolite][:admin_home]}/repositories"}
end

