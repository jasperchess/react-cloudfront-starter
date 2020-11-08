read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS=" = " read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


yarn --frozen-lockfile
yarn build --if-present
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
sudo yarn global add serverless
serverless deploy -s dev
BUCKET=$(read_var WebSiteBucket .env)
echo "${BUCKET}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
aws s3 sync build/ "s3://${BUCKET}" --acl public-read