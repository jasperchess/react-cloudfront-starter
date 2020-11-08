read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS=" = " read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


yarn --frozen-lockfile
yarn build --if-present
sudo yarn global add serverless
serverless deploy -s dev
BUCKET=$(read_var WebSiteBucket .env)
echo "${BUCKET}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
aws s3 sync build/ "s3://${BUCKET}" --acl public-read