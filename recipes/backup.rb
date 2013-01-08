# 
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright 2012, Wil Schultz
#

admin_name      = node["gitolite"]["admin_name"]
backup_dir	= node["gitolite"]["backup_dir"]
backup_device	= node["gitolite"]["backup_device"]

directory "#{backup_dir}" do
  action :create
  recursive true
end

mount "#{backup_dir}" do
  device  "#{backup_device}"
  fstype  "nfs"
  options "defaults,rw,hard,intr,auto"
  pass    0
  action [:mount, :enable]
end

template "backup_gitolite.py" do
  path "/usr/local/bin/backup_gitolite.py"
  source "backup_gitolite_py.erb"
  owner "root"
  group "root"
  mode 0755
end

directory "#{backup_dir}/weekly" do
  action :create
  recursive true
end

cron "this_file_is_managed_by_chef" do
  user "root"
  minute "1"
  hour "1"
  day "1"
  month "1"
  weekday "1"
  command "##### This crontab is managed by chef. #####"
end
cron "backup_gitolite_daily" do
  user "root"
  minute "1"
  hour "1"
  day "*"
  month "*"
  weekday "*"
  command "if [ -d #{backup_dir}/ ]; then rsync  -rltzuv --delete #{backup_device}/ #{backup_dir}/; fi >> /dev/null 2>&1"
end
cron "backup_gitolite_weekly" do
  user "root"
  minute "10"
  hour "1"
  day "*"
  month "*"
  weekday "0"
  command "if [ -d #{backup_dir}/ ]; then /usr/local/bin/backup_gitolite.py; fi >> /dev/null 2>&1"
end

