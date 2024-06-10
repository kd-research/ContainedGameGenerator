FROM unityci/editor:ubuntu-2022.3.29f1-webgl-3.1.0

RUN apt-get update && apt-get install -y curl gnupg2 && apt-get clean
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm install 3.3.0; rvm use 3.3.0 --default"

COPY GameGenerator.gemspec /root/server/GameGenerator.gemspec
COPY Gemfile /root/server/Gemfile
COPY Gemfile.lock /root/server/Gemfile.lock
RUN /bin/bash -l -c "cd /root/server && bundle install"

COPY . /root/server

COPY unity/Unity_lic.ulf /root/.local/share/unity3d/Unity/Unity_lic.ulf
COPY unity/GenerateGame.sh /root/GenerateGame.sh
COPY unity/DefaultSceneBuild.cs /root/SceneBuild.cs

WORKDIR /root/server
ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["bash"]
