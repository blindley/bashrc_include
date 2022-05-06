
function sibd() {
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
    cd "$targetDirectory"
}
