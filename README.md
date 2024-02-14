| screenshots         |
| ------------------- |
| ![](./assets/1.png) |
| ![](./assets/2.png) |
| ![](./assets/3.png) |

### **Dependencies**

- mpc-cli for mpd
- ffmpeg for getting cover art from music files
- `wpctl` and `pactl` for controlling audio

### How to change bar to vertical or horizontal

in `rc.lua` change

```lua
require("bar").setup({
    style = "vertical",
})
```

### Note

I am fetching the default colorscheme from `.Xresources`. To load a custom colorscheme, change it in `theme/pallete.lua`.
