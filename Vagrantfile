# -*- mode: ruby -*-
# vi: set ft=ruby :


CONFIG = File.join(File.dirname(__FILE__), "config.rb")

# Defaults for config options defined in config.rb
$num_minions = 2
$enable_serial_logging = (ENV['SERIAL_LOGGING'].to_s.downcase == 'true')
$vb_gui = (ENV['GUI'].to_s.downcase == 'true')
$vb_node_memory = ENV['NODE_MEM'] || 1024
$vb_node_cpus = ENV['NODE_CPUS'] || 1

if File.exist?(CONFIG)
  require CONFIG
end


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box       = "rancheros"
  config.vm.box_url   = "http://cdn.rancher.io/vagrant/x86_64/prod/rancheros_v0.1.2_virtualbox.box"
  config.ssh.username = "rancher"

  config.vm.provider "virtualbox" do |vb|
     vb.check_guest_additions = false
     vb.functional_vboxsf     = false
     vb.memory = "1024"
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true

  (1..($num_minions + 1)).each do |i|
    hostname = "node-%02d" % i
    memory = $vb_node_memory
    cpus = $vb_node_cpus

    config.vm.define vmName = hostname do |kHost|
      # kHost.vm.hostname = vmName

      ["virtualbox"].each do |h|
        kHost.vm.provider h do |vb|
          vb.gui = $vb_gui
        end
      end
      ["virtualbox"].each do |h|
        kHost.vm.provider h do |n|
          n.memory = memory
          n.cpus = cpus
        end
      end

      ## FIXME: Configure network not supported by the guest OS???
      # kHost.vm.network :private_network, ip: "172.17.8.#{i+100}"

      # Uncomment below to enable NFS for sharing the host machine into the coreos-vagrant VM.
      #config.vm.synced_folder ".", "/home/core/share", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp']
      kHost.vm.synced_folder ".", "/vagrant", disabled: true

    end
  end
end
