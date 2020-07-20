#!/bin/bash

if [ -f "nextepisode" ]; then
	NEXT=$(cat nextepisode)
else
	NEXT="1"
fi

BEFORE=$(ls -l *.ogg | wc -l)

youtube-dl -x -f bestaudio --audio-format vorbis --yes-playlist 'https://www.youtube.com/playlist?list=PL8Xzb2qPbjDEad5--0M8W5TWEOgj_yo1z' --playlist-start=$NEXT --playlist-end=$NEXT --output "%(title)s.%(ext)s" --write-info-json

AFTER=$(ls -l *.ogg | wc -l)

NNEXT=$(expr $NEXT + 1)

if [ "$BEFORE" -ne "$AFTER" ]; then
    YAML_TITLE=$(cat *.info.json | python -m json.tool | grep '\"title\"' | head -n1 | cut -d ':' -f 2 | sed 's/\",.*$//' | sed 's/^.*\"//' | sed 's/[0-9]* - //')
    YAML_YT=$(cat *.info.json | python -m json.tool | grep '\"id\"' | head -n1 | cut -d ':' -f 2 | sed 's/\",.*$//' | sed 's/^.*\"//')
    YAML_EPISODE="$(cat *.info.json | python -m json.tool | grep '\"title\"' | head -n1 | cut -d ':' -f 2 | sed 's/\",.*$//' | sed 's/^.*\"//').ogg"
    YAML_NUMBER=$(cat *.info.json | python -m json.tool | grep '\"title\"' | head -n1 | cut -d ':' -f 2 | sed 's/\",.*$//' | sed 's/^.*\"//' | sed 's/ -.*//' | sed 's/^0*//')
    YAML_DESCRIPTION=$(cat *.info.json | python -m json.tool | grep '\"description\"' | head -n1 | cut -d ':' -f 2 | sed 's/\",.*$//' | sed 's/^.*\"//' | sed 's/Visit.*//')

	echo "$NNEXT" > nextepisode
	
    echo "" >> ../_data/episodes.yaml
	echo "- title: \"$YAML_TITLE\"" >> ../_data/episodes.yaml
	echo "  yt: \"$YAML_YT\"" >> ../_data/episodes.yaml
	echo "  episode: \"$YAML_EPISODE\"" >> ../_data/episodes.yaml
	echo "  number: $YAML_NUMBER" >> ../_data/episodes.yaml
	echo "  description: \"$YAML_DESCRIPTION\"" >> ../_data/episodes.yaml
	
	rm *.info.json
fi

