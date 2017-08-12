# FFMPEG_ONLINE

##1.  Build docker container
```
docker-compose build
```

##2. Launch container
```
docker-compose up -d
```
After running this command make sure your container is launched by execute below command:
```
docker-compose ps
```
The result should be like this
```
       Name                     Command               State           Ports          
------------------------------------------------------------------------------------

ffmpegonline_db_1    docker-entrypoint.sh postgres    Up      5432/tcp               

ffmpegonline_web_1   bundle exec rails s -p 300 ...   Up      0.0.0.0:3000->3000/tcp 

```
Now, you can test your site by access localhost:3000.


##3. Init ffmpeg supported formats
In rails console, run below command
```
load Dir.pwd.to_s + "/app/assets/ffmpeg_document/format_process.rb"
```