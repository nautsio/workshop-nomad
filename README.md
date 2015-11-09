# Dutch Docker Day Nomad workshop
The packer build files and resulting vagrant box setup for the Dutch Docker Day Nomad workshop.

## Create the vagrant box.
To build the vagrant box, run in the packer directory:
```
// Move to the packer directory.
cd packer

// Build the box.
packer build dutchdockerday.json
```

To change the contents of the vagrant box change the provision scripts in the packer/scripts directory and alter the list of scripts that is called:
```
"scripts": [
  "scripts/vagrant.sh",     // Set up the vagrant ssh keys.
  "scripts/packages.sh",    // Install general use packages.
  "scripts/nomad.sh",       // Install Nomad.
  "scripts/consul.sh",      // Install Consul.
  "scripts/docker.sh"       // Install docker.
]
```

## Start the vagrant box.
To start the vagrant box, run in the vagrant directory:
```
// If we are still in the packer directory, go back one..
cd ..

// Move into the vagrant directory.
cd vagrant

// Start 1 box:
vagrant up ddd-01

// Start all (by default) 3 boxes:
vagrant up
```

## Connect to the vagrant box.
To ssh into the started vagrant box, run in the vagrant directory:
```
// SSH into a specific box.
vagrant ssh ddd-01
```

## Destroy the vagrant box.
To destroy the vagrant box again, run in the vagrant directory:
```
// Destroy one vagrant box.
vagrant destroy -f ddd-01

// Destroy all vagrant boxes.
vagrant destroy -f
```
