# Caution

- ⚠️ Do not forget to go through .nix, configuration.nix and edit and comment out (#) anything you don't want to setup!

# Install

```bash
git clone https://github.com/IceDBorn/IceDServer
cd IceDServer
bash install.sh
```

# Known Issues

### error: Entry '.configuration-location' not uptodate. Cannot merge.

Solution:

```
git rm --cached --sparse .configuration-location
```

### error: Entry 'hardware-configuration.nix' not uptodate. Cannot merge.

Solution:

```
git rm --cached --sparse hardware-configuration.nix
```
