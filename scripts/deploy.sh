read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS=" = " read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

echo "---------------- Prepare build ----------------"
yarn --frozen-lockfile
yarn build --if-present

echo "---------------- Creating Cloudformation Stack ----------------"
sudo yarn global add serverless
BRANCH=$(echo $GITHUB_REF | awk 'BEGIN { FS = "/" } ; { print $3 }')
serverless deploy -s "${BRANCH}"

BUCKET=$(read_var WebSiteBucket .env)
echo "---------------- Publishing to bucket ${BUCKET} ----------------"
aws s3 sync build/ "s3://${BUCKET}" --acl public-read

DISTRIBUTION=$(read_var DistributionID .env)
echo "---------------- Invalidating ${DISTRIBUTION} cache ----------------"
aws cloudfront create-invalidation --distribution-id "${DISTRIBUTION}" --paths "/*"