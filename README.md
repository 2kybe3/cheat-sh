# cheat-sh
A tiny wrapper for [cheat.sh](https://cheat.sh/)

---

[![Demo](https://i.kybe.xyz/u/VuzBfmq5zwyAwcw)](https://i.kybe.xyz/u/lwVG4ztPxZz01Xn.mp4)

---

## ENV


| Variable | Values | Description |
| -------- | ------ | ----------- |
| `CHEAT_SHEAT_DEBUG`  | `true` / `false` | Enables debug output |
| `CHEAT_SHEAT_VIEWER` | `less`, `bat`, `...` | Pager used to display results |

---

## Examples

### Simple usage
```bashbash
nix run github:2kybe3/nix-dotfiles\?dir=tools/cheat-sh
```

### print result using bat

```bash
CHEAT_SHEAT_VIEWER=bat nix run github:2kybe3/nix-dotfiles\?dir=tools/cheat-sh
```

![output](https://i.kybe.xyz/u/JRqnlUdueOJTTvy)
