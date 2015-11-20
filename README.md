# Dutch Docker Day Nomad workshop

## Start the vagrant box.
To start the vagrant box, run in the vagrant directory:
```
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
