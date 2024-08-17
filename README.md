# Private Sync

A simple program to sync files between PCs by using a SSH server. No server side software required, just your SSH server.

It will keep track of the files modified timestamp and ensure the latest version of the file is downloaded and uploaded to and from the SSH server.

Its been designed with a single user in mind. If multiple people are modifying files and its syncing then expect data loss. This will not work with different users modifying the same files.

At the moment it will use your key in `~/.ssh/id_rsa`

Contact me on my website [likefury.com](https://likefury.com).

### To Do
1. Handle file deletion
2. Better docs
3. A detailed guide
4. More SSH authentication options
5. Option to sync individual files
6. Periodic syncs

## Build

Make sure you have the Dart build tools installed on your system.

````
git clone https://github.com/LikeFury/private-sync
cd private-sync
dart compile exe ./bin/private_sync.dart
sudo cp ./bin/private_sync.exe /usr/bin/private-sync
sudo chmod +x /usr/bin/private-sync
````

## How to use

#### Display Help Options:
```
private-sync help
```

### Setup the SSH server
#### Set your SSH Server Hostname:
```
private-sync server hostname 192.168.1.2
```

#### Set the directory on your SSH server too store the files:
```
private-sync server directory /root/syncedfiles/
```

#### Set the username you use for your SSH server:
```
private-sync server username root
```

#### Test the SSH server connection:
```
private-sync server test
```

### Setup directories to sync

#### Add directory to be synced
```
private-sync directory add
```
Enter in the name, example `documents` and then the directory path you want synced, for example `~/Documents`


#### Show configured directories
```
private-sync directory show
```

#### Show the names of synced directories on the server
```
private-sync directory remote
```

### Run a Sync

#### Sync the files to your SSH server:
```
private-sync sync
```

On your other PC run through the same step of commands and use the same directory name. The files will be synced between those directories.

