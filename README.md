# Budabot + AOChatProxy
This is meant as a small example as of how to run Budabot + AOChatProxy with the help of docker and docker-compose.  
The benefits of this, among others:  
- Easy to setup and get started  
- Super easy to run multiple versions of the bot / proxy side by side  
- Portable, you can run it on any platform where docker runs   

## Requirements
For this to work, you will need:  
- docker
- docker-compose (optional, but you will have to handle orchestration in some other way)  
- make (optional, but you'll have to run the commands manually)  
- budabot.db for the org/bot you'd want to run

## Getting started
First of all, you'll have to make sure you have all the requirements.  
Then, update the config.php with appropriate values for `login`, `password`, `name`, `my_guild` and `super_admin`.   
Second, update the proxy.properties with appropriate values for `slave1_username`, `slave1_password`, `slave1_characterName`.  

## Start bot and proxy
When you are done configuring, simply launch a shell in the repository root and type:  
```bash
make build run
```

## Extending
In order to run multiple bots, the easiest way is to create a directory for each bot/proxy, and store the configuration files within it.  
Then update the docker-compose.yml file, copy the `orgbot` and `orgproxy` services, name them them according to your org, update the path for `budabot.db`, `config.php` and `proxy.properties` to include the name of the folder.  
You could then either add separate make targets for each bot/proxy, or simply type:  
```bash
docker-compose up --build --force-recreate myorgbot
```
