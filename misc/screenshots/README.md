# screenshots

```sh
sudo fbgrab -c 2 login_screen.png

magick \
    -size 1920x1080 \
    xc:black \
    /usr/share/systemd/bootctl/splash-arch-custom.bmp \
    -gravity center \
    -composite \
    bootsplash.png
```
