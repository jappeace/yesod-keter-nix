[![https://jappieklooster.nl](https://img.shields.io/badge/blog-jappieklooster.nl-lightgrey)](https://jappieklooster.nl/tag/haskell.html)
[![Jappiejappie](https://img.shields.io/badge/discord-jappiejappie-black?logo=discord)](https://discord.gg/Hp4agqy)
# Example yesod + keter + nix

This is an exmple of how to nixify a yesod
app and how to run it in keter.
The app itself is the [yesod postgres template](https://github.com/yesodweb/yesod-scaffold/tree/postgres)

run the example with

```
nix -Lv build .#example
```

`nix/server.nix` shows how to configure your configuration.nix file.
whereas the `flake.nix` shows how to flakify your project.
`backend` contains the standard yesod postgres template.
It's moved to backend so nix changes don't cause a recompilation.


Contact me if you need help.

# Notes

+ The settings file in backend/config/keter.yml is ignored by the nix expression
  in the standard template.
  I deleted it in this to reflect that.
+ I removed the upper bounds of the app. Nix does pinning of versions. 
  doing this as well in the package.yaml results in a lot of extra work.

# License

MIT
