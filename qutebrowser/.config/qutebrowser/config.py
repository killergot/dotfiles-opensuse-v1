# config.py
config.load_autoconfig()
# config redactor by :config-edit
c.editor.command = ["kitty", "nvim", "{file}"]

telegram_hints = {
    **c.hints.selectors,
    "all": list(c.hints.selectors["all"]) + [
        ".menu-horizontal-div-item",
    ],
}

config.set("hints.selectors", telegram_hints, "https://web.telegram.org/*")
config.set("hints.selectors", telegram_hints, "https://webk.telegram.org/*")


# hjkl
config.bind('р', 'scroll left')   # h
config.bind('о', 'scroll down')   # j
config.bind('л', 'scroll up')     # k
config.bind('д', 'scroll right')  # l

# opening / hints
config.bind('щ', 'cmd-set-text -s :open')       # o
config.bind('Щ', 'cmd-set-text -s :open -t')    # O
config.bind('а', 'hint')                        # f
config.bind('А', 'hint all tab')                # F

# tabs / navigation
config.bind('О', 'tab-next')     # J
config.bind('Л', 'tab-prev')     # K
config.bind('Р', 'back')         # H
config.bind('Д', 'forward')      # L

# common actions
config.bind('в', 'tab-close')    # d
config.bind('г', 'undo')         # u
config.bind('к', 'reload')       # r
config.bind('К', 'reload -f')    # R
config.bind('ш', 'mode-enter insert') # i

# search
config.bind('т', 'search-next')  # n
config.bind('Т', 'search-prev')  # N

# gg / G
config.bind('пп', 'scroll-to-perc 0')  # gg
config.bind('П', 'scroll-to-perc')     # G

# yank
config.bind('нн', 'yank')       # yy
config.bind('нз', 'yank pretty-url')  # yp

c.bindings.key_mappings = {
    'ф': 'a',
    'ы': 's',
    'в': 'd',
    'а': 'f',
    'п': 'g',
    'р': 'h',
    'о': 'j',
    'л': 'k',
    'д': 'l',
}
