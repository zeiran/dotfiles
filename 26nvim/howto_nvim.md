
## Переменные окружения на рабочей тачке

Вим немножко сходит с ума из-за того, что рабочий логин у меня alexeev_ev@avp.ru, а домашняя директория - просто alexeev_ev.

Исправлено явным прописыванием XGD директорий в .profile:

```
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/tmp/user-$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
fi
export XDG_DATA_HOME="$HOME/.local/share/"
export XDG_CONFIG_HOME="$HOME/.config/"
export XDG_STATE_HOME="$HOME/.local/state/"
export XDG_CACHE_HOME="$HOME/.cache/"
```

А потом похожие ошибки стали вылезать в cmake-tools, поэтому я просто сделал симлинк
```
sudo ln -s /home/alexeev_ev /home/alexeev_ev@avp.ru
```
