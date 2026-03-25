# Nix flake laravel template

### How to use

Init flake template
```sh
nix flake init -t github:Malsoryz/Malsoryz?ref=idk&dir=Nix#laravel
```

Use devshell
```sh
nix develop .#<php-version>
```
change `php-version` to one in "php84", "php83" or "php82". default use "php84".

---

### Note
Untuk sekarang menggunakan branch `idk` saja dan berada di dalam folder `Nix`.