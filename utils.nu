export def env-has [key: string]: nothing -> bool {
    $env | get -i $key | is-not-empty
}
