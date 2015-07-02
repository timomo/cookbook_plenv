#
# Cookbook Name:: plenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
group "plenv" do
  action :create
end

git "/opt/plenv" do
  repository "git://github.com/tokuhirom/plenv.git"
  revision "master"
  user "root"
  group "plenv"
  action :sync
end

directory "/opt/plenv/plugins" do
  action :create
end

git "/opt/plenv/plugins/perl-build" do
  repository "git://github.com/tokuhirom/Perl-Build.git"
  revision "master"
  user "root"
  group "plenv"
  action :sync
end

template "/etc/profile.d/plenv.sh" do
  source "profile.d/plenv.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

yum_package "perl-ExtUtils-MakeMaker.x86_64" do
  action :upgrade
end

yum_package "patch.x86_64" do
  action :upgrade
end

yum_package "gcc.x86_64" do
  action :upgrade
end

# see also: http://easyramble.com/chef-execute-source-error.html
bash "install cpanm" do
  code <<-_EOH_
    source /etc/profile.d/plenv.sh
    plenv install-cpanm
  _EOH_
  not_if { File.exist?("/opt/plenv/shims/cpanm") }
end

# install perl 5.10.1
bash "install perl" do
  code <<-_EOH_
    source /etc/profile.d/plenv.sh
    plenv install 5.10.1
    plenv global 5.10.1
  _EOH_
  not_if { File.exist?("/opt/plenv/shims/perl") }
end
