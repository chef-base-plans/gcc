title 'Tests to confirm gcc works as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "gcc")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-gcc' do
  impact 1.0
  title 'Ensure gcc is working as expected'
  desc '
  We first check that the gcc & gcc.real executables are present and then runs version checks on both to verify that they are executable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  gcc_version = command("#{File.join(target_dir, "gcc")} -v")
  describe gcc_version do
    its('stdout') { should be_empty }
    its('stderr') { should match /gcc version [0-9].[0-9].[0-9]/ }
    its('exit_status') { should eq 0 }
  end

  gcc_real_version = command("#{File.join(target_dir, "gcc.real")} -v")
  describe gcc_real_version do
    its('stdout') { should be_empty }
    its('stderr') { should match /gcc version [0-9].[0-9].[0-9]/ }
    its('exit_status') { should eq 0 }
  end
end
