Game Generator docker image
====

## Instruction

This image requires a 'shared' folder mounted to /root/shared in container. This folder should optionally contain the following files:

- `game.json`: a JSON file containing the game configuration
- `SceneBuild.cs`: a C# file containing the scene build script

## Build

To build the image, use the following command:

```bash
docker build -t game-generator:test .
```

## Usage

To run the container, use the following command:

```bash
mkdir /path/to/shared

# Case 1: Run the container with shared folder with no additional files
docker run -v /path/to/shared:/root/shared game-generator

# Case 2: Run the container with shared folder with game.json
docker run -v /path/to/shared:/root/shared game-generator game.json

# Case 3: Run the container with shared folder with SceneBuild.cs
docker run -v /path/to/shared:/root/shared game-generator SceneBuild.cs
```

