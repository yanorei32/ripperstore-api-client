#!/bin/bash

# ref: https://ripper.store/clientarea
RS_APIKEY='<YOUR API KEY>'

# ref: https://github.com/CodeAngel3/RipperStoreCredits/blob/main/Main.cs
RS_VERSION='5'

NAME='KaniPoke'
DESCRIPTION='Kani Poke'
AVATAR_ID='avtr_9386dbe5-e337-45c5-9cc4-bce62ce6955d'
VERSION='3'

# public / private
RELEASE_STATUS='public'

AUTHOR_NAME='yanorei32'
AUTHOR_ID='usr_a3e82402-d040-457a-ab91-62428be09b12'

# thumbnail domain: d348imysud55la.cloudfront.net / api.vrchat.cloud / files.vrchat.cloud
ASSET_URL='https://api.vrchat.cloud/api/1/file/file_e458b2d8-3284-4508-8e8f-a4b6c8894a94/2/file' # validated
IMAGE_URL='https://api.vrchat.cloud/api/1/file/file_8b1323d8-ecef-4c80-ad7d-ff5b424199be/1/file' # validated
THUMBNAIL_IMAGE_URL='https://api.vrchat.cloud/api/1/image/file_8b1323d8-ecef-4c80-ad7d-ff5b424199be/1/256' # maybe unused

# Unknown: True / False
FEATURED='False'

# Unity Version: 5.6.3p1, 2017.4.15f1, 2018.4.20f1, etc..
UNITY_VERSION='2018.4.20f1'

# Supported platforms: All, StandaloneWindows, ...?
SUPPORTED_PLATFORMS='StandaloneWindows'

# Requried by hash
WORLD_ID="wrld_$(uuidgen)"

# calculate hash (???)
HASH=$(
	echo -n "${AVATAR_ID}|${ASSET_URL}|${IMAGE_URL}|${WORLD_ID}" \
		| xxd -p -u \
		| tr -d '\n' \
		| fold -w 2 \
		| tr '\n' '-'
)

# fake pointer
POINTER=$(expr 2760234445248 + ${RANDOM})

JSON=$(
	cat base.json \
		| sed "s/##HASH##/${HASH}/" \
		| sed "s/##NAME##/${NAME}/" \
		| sed "s,##IMAGE_URL##,${IMAGE_URL}," \
		| sed "s/##AUTHOR_NAME##/${AUTHOR_NAME}/" \
		| sed "s/##AUTHOR_ID##/${AUTHOR_ID}/" \
		| sed "s,##ASSET_URL##,${ASSET_URL}," \
		| sed "s/##DESCRIPTION##/${DESCRIPTION}/" \
		| sed "s,##THUMBNAIL_IMAGE_URL##,${THUMBNAIL_IMAGE_URL}," \
		| sed "s/##VERSION##/${VERSION}/" \
		| sed "s/##RELEASE_STATUS##/${RELEASE_STATUS}/" \
		| sed "s/##FEATURED##/${FEATURED}/" \
		| sed "s/##UNITY_VERSION##/${UNITY_VERSION}/" \
		| sed "s/##SUPPORTED_PLATFORMS##/${SUPPORTED_PLATFORMS}/" \
		| sed "s/##ID##/${AVATAR_ID}/" \
		| sed "s/##POINTER##/${POINTER}/"
)

SERVER='https://api.ripper.store'
TARGET="${SERVER}/clientarea/credits/submit?apiKey=${RS_APIKEY}&v=${RS_VERSION}"

echo $TARGET
echo $JSON
echo Press return to send request...

read
curl \
	-v \
	-X POST \
	-H 'User-Agent:' \
	-H 'Content-Type: application/json' \
	--data "${JSON}" \
	"${TARGET}"

echo Exit Code: $?
