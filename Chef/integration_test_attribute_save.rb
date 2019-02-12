# DESCRIPTION: The code in this file can be used to easily bring the converged attributes into ServerSpec for use in
#             testing

# ========================== Put this code in your default recipe ==========================

if ENV['TEST_KITCHEN']
	# This section exports the node attributes to be used for inspec tests
	ruby_block 'Save node attributes' do
		block do
		  tmp_path = if node['platform_family'] == 'windows'
			'C:\\Temp\\kitchen'
		  else
			'/tmp/kitchen'
		  end
		  FileUtils.mkdir_p(tmp_path) unless File.directory?(tmp_path)
		  IO.write(File.join(tmp_path, 'chef_node.json'), node.to_json)
		end
	end # ruby_block 'Save node attributes'
end

# ========================== Put this code in the tests ==========================
require 'json'

if os.windows?
  tmp_path = 'C:\\Temp\\kitchen'
elsif os.linux?
  tmp_path = '/tmp/kitchen'
end
json_file_path = File.join(tmp_path, 'chef_node.json')

# Test to make sure the json file is created first
describe file(json_file_path) do
  it { should exist }
end
node = json(json_file_path).params # Load the json file