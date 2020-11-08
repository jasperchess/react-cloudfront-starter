read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS=" = " read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

MY_VAR=$(read_var WebSiteBucket .env)

echo $MY_VAR