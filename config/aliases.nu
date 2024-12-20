export alias la = ls -a
export alias ll = ls -al
export alias l = la

export alias lz = lazygit
export alias n = nvim

export alias gf = git fetch
export alias gs = git status
export alias gp = git push
export alias gg = git pull
export alias gc = git commit

# take command from zsh
export def --env t [dir_name?: string] {
    let dir_name = if not ($dir_name | is-empty) { $dir_name } else { $in }
    mkdir $dir_name
    cd $dir_name
    l .. | where name == $"../($dir_name)"
}

# MacOS fix
export alias nopen = open
export alias no = open
export alias open = ^open

