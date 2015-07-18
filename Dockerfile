FROM smithjw/frank

RUN apt-get update
RUN apt-get -y install expect redis-server nodejs npm

RUN apt-get update && \
    apt-get install -y python-pip &&\
    pip install awscli
    
RUN apt-get clean && \
    rm -f /var/lib/apt/lists/*
    
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g coffee-script
RUN npm install -g yo generator-hubot

# Create hubot user
RUN    useradd -d /frank -m -s /bin/bash -U frank

# Log in as hubot user and change directory
USER    frank
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="James <james@cultureamp.com>" --name="frank" --defaults

# Adapters/scripts
RUN npm install hubot-slack --save && npm install
RUN npm install hubot-standup-alarm --save && npm install
RUN npm install hubot-auth --save && npm install
RUN npm install hubot-google-translate --save && npm install
RUN npm install hubot-auth --save && npm install
RUN npm install hubot-github --save && npm install
RUN npm install hubot-alias --save && npm install
RUN npm install hubot-gocd --save && npm install
RUN npm install hubot-youtube --save && npm install

#Activate some built-in scripts
ADD hubot/hubot-scripts.json /hubot/
ADD hubot/external-scripts.json /hubot/

RUN npm install cheerio --save && npm install
ADD hubot/scripts/huebot-lietwerk.coffee /hubot/scripts/
ADD hubot/scripts/hubot-lunch.coffee /hubot/scripts/

# And go
CMD ["/bin/sh", "-c", "aws s3 cp --region ap-southeast-2 s3://franks-creds/env.sh .; . ./env.sh; bin/hubot --adapter slack"]
