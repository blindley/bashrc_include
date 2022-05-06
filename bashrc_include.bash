
function sibd() {
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "sibd"
        echo -n "    Change the shell working directory to the next sibling. i.e, the next "
        echo "subdirectory of the parent of the current directory"
        return 0
    fi

    local thisDirectory="$(pwd | sed 's|.*/|../|')"

    local awkScript='
            {
                if (getNextDirectory) {
                    nextDirectory = $0;
                    exit 0;
                }
                if (! firstDirectory) {
                    if ($0 != "..") {
                        firstDirectory = $0;
                        nextDirectory = firstDirectory;
                    }
                };
                if ($0 == thisDirectory) {
                    getNextDirectory = "true";
                }
            }
            END {
                print nextDirectory;
            }
        '

    local targetDirectory="$(find .. -maxdepth 1 -type d | awk -v thisDirectory="$thisDirectory" -- "$awkScript")"
    pushd "$targetDirectory"
}

