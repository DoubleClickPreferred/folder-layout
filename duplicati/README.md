# Installation

1. Copy this note and the scripts in `C:/home/duplicati/`.
2. Set the proper _BACKUP-KEYNAME_ & _REPOSITORIES-KEYNAME_ in all the scripts: it is the name of your USB drive. 
3. Set the proper _PASSPHRASE_ too, to encrypt your backup: it is a text of your choice. More info in [Duplicati documentation](https://docs.duplicati.com/en/latest/06-advanced-options/#passphrase)
4. Adapt the path to PortableGit in `2-clone-core.bat` as your version number may differ.
5. Organize your workspace on `C:` as shown below, create folders `B:/backup/` and `R:/repositories/work`, and create the file  `B:/backup/my_backup_is_here.txt`.
6. Execute `999-backup.bat` to backup all the files of `C:/home/static/`.
7. Use Git/Sourcetree to clone your repositories to `R:`

# Folder layouts

I store all my files in _C:/home/_ in three sub-folders:

1. _core/_, Git clone of the project with the configuration of my PC
2. _static/_, all my non-code files, backed up by Duplicati
3. _work/_, all my code projects

Two devices for backup are needed:

- the backup drive **B:**, to backup the _static/_ folder
- the repositories drive **R:** to clone all my projects of the _work/_ folder + the core project

Each folder layout is as follows:

```
C:/home/
  core/                   --> clone of the core project from R:/repositories/core/
  duplicati/              --> image of B:/home/duplicati/, scripts of backups and restores + the Duplicati database file
  static/                 --> sole folder backed up by Duplicati
  work/                   --> contains any Git clone from R:/repositories/work/

B:/
  backup/                 --> contains all the backed up files of the C:/home/static/ folder
    my_backup_is_here.txt --> empty file to indicate to Duplicati where to store the backup files
  home/
    duplicati/            --> image of C:/home/duplicati/, scripts of backups and restores + the Duplicati database file

R:/
  repositories/
    core/                 --> Git repository of the core project
    work/                 --> contains all my Git repositories
```

# Backup

Just execute `999-backup.bat`.

# Install a new PC

## Case A: main PC

0. from the backup drive, copy the _B:/home/duplicati/_ folder to _C:/home/duplicati/_ on the new PC.
1. install Duplicati thanks to the installer in this _duplicati/_ folder
2. keep the backup drive connected & use _999-restore-all.bat_ to get back the whole _C:/home/static/_ folder
3. connect the repositories drive & use _2-clone-core.bat_ to get the _core_ project, which contains all the rest of programs to initialize a new PC.

## Case B: secondary PC

0. from the backup drive, copy the _B:/home/duplicati/_ folder to _C:/home/duplicati/_ on the new PC.
1. install Duplicati thanks to the installer in this _duplicati/_ folder
2. keep the the backup drive connected & use _1-restore-bin-folder.bat_ to get back all portable programs, including Git, the terminal and Notepad++ in _C:/home/static/bin/_
3. connect the drive with the repositories & use _2-clone-core.bat_ to get the _core_ project, which contains all the rest of programs to initialize a new PC.

The idea is to keep the _duplicati/_ folder as small as possible. The installation mostly depends on the _core_ project which is tracked by Git and hold all the sophisticated features.
