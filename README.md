# lfs272-assets

Create compressed tar archive:

```
tar --exclude='./lfs272-assets/.git' --exclude='./lfs272-assets/.gitignore' \
    --exclude='./lfs272-assets/.DS_Store' \
    --exclude='./lfs272-assets/README.md' \
    -czvf ./lfs272-assets/lfs272-assets.tgz lfs272-assets
```

Uncompress tar archive:

```
tar -xvf lfs272-assets.tgz
```