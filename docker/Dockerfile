# Use an appropriate base image
FROM unityci/editor:ubuntu-2022.3.29f1-webgl-3.1.0

COPY ./Unity_lic.ulf /root/.local/share/unity3d/Unity/Unity_lic.ulf
COPY ./GenerateGame.sh /root/GenerateGame.sh
COPY ./DefaultSceneBuild.cs /root/SceneBuild.cs

WORKDIR /root
ENTRYPOINT ["./GenerateGame.sh"]
CMD []
