# Nushell Environment Config File
#
# version = "0.99.1"

use std "path add"

$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

let distro = (sys host | get name)
# NOTE: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}


if $distro != "Windows" {
    let bins = [
        "/usr/local/bin"
        "/opt/homebrew/bin"
        "/home/linuxbrew/.linuxbrew/bin"
        "/home/linuxbrew/.linuxbrew/bin"
        ($env.HOME | path join .local/bin)
        ($env.HOME | path join go/bin)
        ($env.HOME | path join .cargo/bin)
        ($env.HOME | path join bin)
    ] | where (path exists)
    $env.PATH = ($env.PATH | split row (char esep) | prepend $bins)

    if ($env.HOME | path join .bun | path exists) {
        $env.BUN_INSTALL = ( $env.HOME | path join .bun )
        path add ($env.HOME | path join .bun/bin)
    }
}

if not (which fnm | is-empty) {
    fnm env --json | from json | load-env
    $env.FNM_BIN = ($env.FNM_DIR | path join bin)
    $env.FNM_MULTISHELL_PATH = ($env.FNM_DIR | path join nodejs)
    path add $env.FNM_BIN
    let node_path = if $distro == "Windows" {
        $env.FNM_MULTISHELL_PATH
    } else {
        $env.FNM_MULTISHELL_PATH | path join bin
    }
    path add $node_path
} else {
    print 'fnm not found'
}

if not (which vivid | is-empty) {
    $env.LS_COLORS = (vivid generate tokyonight-storm)
} else {
    print 'vivid not found'
}

if not (which starship | is-empty) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
}

$env.EDITOR = 'nvim'

