USERNAME="docker_user"
PASSWORD="docker_pass"
ORGANIZATION="docker_user"
IMAGE="Image_name"
TAG="1.1 1.2 1.3 1.29"

login_data() {
cat <<EOF
{
  "username": "$USERNAME",
  "password": "$PASSWORD"
}
EOF
}

TOKEN=`curl -s -H "Content-Type: application/json" -X POST -d "$(login_data)" "https://hub.docker.com/v2/users/login/" | jq -r .token`

for i in $TAG
do
curl "https://hub.docker.com/v2/repositories/${ORGANIZATION}/${IMAGE}/tags/${i}/" \
-X DELETE \
-H "Authorization: JWT ${TOKEN}"
done
