#!/bin/bash
set -xe

# path to unity
unity_path="/opt/unity/Editor/Unity"

if [ -z "$2" ]; then
	echo "Using default game specs file: SceneBuild.cs"
	GAME_SPECS_FILE=/root/SceneBuild.cs
else
	echo "Using custom game specs file: $1"
	GAME_SPECS_FILE=/root/shared/$1
fi

GAME_DIR=$1

# create new unity project
echo "Creating new empty Unity project"
"$unity_path" -batchmode -nographics -quit -createProject "$GAME_DIR"

pushd "$GAME_DIR"

# create required directories
echo "Creating required directories"
mkdir -p "$GAME_DIR"/Assets/Scenes/
mkdir -p "$GAME_DIR"/Assets/Scripts/Editor/

# copy game specification to Scripts/Editor/
echo "Copying GameSpecs.cs to Assets/Scripts/Editor/"
cp "$GAME_SPECS_FILE" "$GAME_DIR"/Assets/Scripts/Editor/

# build game using command line args
echo "Starting new scene generation..."
"$unity_path" -batchmode -nographics -quit -projectPath "" -logfile - -executeMethod SceneBuild.GenerateScene

echo "Scene generation completed..."
echo "Starting WebGL build..."
"$unity_path" -batchmode -nographics -quit -projectPath "" -logFile - -executeMethod SceneBuild.BuildWeb
echo "WebGL build completed..."
