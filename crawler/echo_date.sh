echo_date() {
    python ./test.py
    sleep 5;
}
echo_date | tee -a ~/echo_date.log