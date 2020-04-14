function main_command() {
    echo "command run at -> $(date +\"%Y-%m-%d\ %H:%M:%S\")"
    python3 ./test.py
    sleep 1;
}
main_command | tee -a ~/main_command.log