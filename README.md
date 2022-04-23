# Some scripts to handle Matomo DB

## Usecase:  

I need to run continues integration tests with prod like DB structure.
I'm not the only one tampering with the installation. So fixtures are no good for me. I need to know what is broken when something changes. But I don't want to run all tests against a huge database. So I dump what I need to create a prod like scenario.

Will it matter? IDK, time will tell...  
Will I learn something? Most Def!

## Get Prod DB

For PROD env, run a cronjob that executes `dump-ci-raw.sh` nightly.

## Then prep the DB for CI

I could, if I want, run the prep on the prod server. But because of reasons, I do it in a separate controlled environment, with no access from the Internetz.

Run prep the DB.
```bash
./scripts/prep-ci-db.sh
```


## Whattabout all the other crap

```
tree
.
├── README.md                   README obviously.
├── docker-compose-ci.yml       A simple docker-compose file with bare minimum.
├── dumps                       This is where I store the dumps.
│   └── matomo-ci.sql           A production dump after it has been gunzipped, gitignored in case of sensitive content.
├── env.sample                  A template for my .env file.
├── logs                        For debugging.
│   └── mysql-commands.log      Example file of logs.
├── matomo-ci-conf              Folder to keep conf.
│   └── config.ini.php          Matomo is a bit tricky with env files, gitignored.
├── mysql_data                  Folder for mysql related stuff.
│   ├── init.sql                Did some trials and errors, removed it.
│   ├── runtime                 Worthless.
│   └── schema.sql              Create a DB, Useful.
└── scripts                     My intention wasn't to end up with a bunch of scripts. But for organizing.
    ├── All-tables.sh           An Example file, keeping so I can revisit my thoughts at a later point.
    ├── TABLE_SIZES.sql         Useful Query to identify large tables.
    ├── check-env.sh            Bad habit of keeping stuff in env files. Room for improvement I know.
    ├── destroy.sh              When you're pulling your hair out. Remember that you can always start from scratch!
    ├── dump-ci-raw.sh          This is for getting the originl DB dump. With some "Data Cleansing"!
    ├── fetch-dump.sh           Just a reminder for how to get stuff with Minio.
    ├── ignore-tables.sh        E.g ignore blobs to meassure how long it takes to restore. Not used anymore.    
    ├── import_ci_dump.sh       Some things are really easy, but hard to remember.
    └── prep-ci-db.sh           The reason why I created this repo from the first place, takes for ever to do this stuff manually!
```
