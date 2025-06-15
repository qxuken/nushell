use ../themes/catppuccin-latte.nu
use ../themes/catppuccin-mocha.nu

# https://github.com/nushell/nu_scripts/tree/main/themes

def is-dark [] {
    if ((sys host | get name) == 'Windows') {
        return true
    }
    let res = term query $'(ansi osc)11;?(ansi st)' --prefix $'(ansi osc)11;' --terminator (ansi st)
    | decode
    | parse "rgb:{r}/{g}/{b}"
    | into record
    let r = $res.r | str substring 0..1 | into int --radix 16
    let g = $res.g | str substring 0..1 | into int --radix 16
    let b = $res.b | str substring 0..1 | into int --radix 16
    let brightness = ($r * 299 + $g * 587 + $b * 114) / 1000
    $brightness < 128
}

export def --env rt [] {
    let is_dark = is-dark

    $env.TERM_APEARANCE = if $is_dark {
        'Dark'
    } else {
        'Light'
    }
    $env.config.color_config = if $is_dark {
        (catppuccin-mocha)
    } else {
        (catppuccin-latte)
    }

    if (which vivid | is-not-empty) {
        $env.LS_COLORS = if $is_dark {
            (vivid generate catppuccin-mocha)
        } else {
            (vivid generate catppuccin-latte)
        }
    } else {
        print 'vivid not found'
    }
}

rt
