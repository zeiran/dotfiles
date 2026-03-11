:colorscheme industry
:edit %:p:h/keyhelp
:syn match Type /= \w[^=]* =/
:syn match Conceal /[\[\]]/ contained
:syn match Character /\[[^\]]*\]/ contains=Conceal
