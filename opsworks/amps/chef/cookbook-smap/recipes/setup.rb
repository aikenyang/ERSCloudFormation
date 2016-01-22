# Install python26, postfix, protobuf from s3
# Stop sendmail, start postfix

include_recipe 'deploy'
require 'aws-sdk'

s3 = AWS::S3.new







# Download postfix rpm, hard code for now, should be put in cloud formation template
bucket_name = 'coretech-ers'
obj_name = 'packages/3rd-party/postfix-2.10.2-1.rhel6.x86_64.rpm'
file_path_postfix = '/home/postfix-2.10.2-1.rhel6.x86_64.rpm'

obj = s3.buckets["#{bucket_name}"].objects["#{obj_name}"]
file_content = obj.read

file "#{file_path_postfix}" do
  owner 'root'
  group 'root'
  mode '0644'
  content file_content
  action :create
end

# Install postfix
rpm_package "#{file_path_postfix}" do
  action :install
end

# download protobuf rpm
obj_name = 'packages/3rd-party/protobuf-2.5.0-16.1.x86_64.rpm'
file_path_protobuf = '/home/protobuf-2.5.0-16.1.x86_64.rpm'

obj = s3.buckets["#{bucket_name}"].objects["#{obj_name}"]
file_content = obj.read

file "#{file_path_protobuf}" do
  owner 'root'
  group 'root'
  mode '0644'
  content file_content
  action :create
end

# Install protobuf
rpm_package "#{file_path_protobuf}" do
  action :install
end

# Install python26
yum_package 'python26' do
  action :install
end


# Stop sendmail
service "sendmail" do
  action :stop
end

# Start postfix
service "postfix" do
  action :start
end
# Should we create spambot automatically?