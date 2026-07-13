# Alfred preferences

This folder contains the actual Alfred preferences bundle:

```text
config/alfred/
└── Alfred.alfredpreferences/
```

It is intentionally kept separate from the other configuration categories.
The bundle contains Alfred's preferences, workflows, and related Alfred-managed
configuration files. This repository does not install Alfred or automatically
replace an existing Alfred configuration.

## Make Alfred read these files

1. Install Alfred and open **Alfred Preferences**.
2. Open the **Advanced** tab.
3. Find **Syncing** and choose **Set preferences folder**.
4. Select this repository's `config/alfred/` directory, for example:

   ```text
   ~/code/dotfiles/config/alfred
   ```

5. Confirm Alfred's prompt to use the existing preferences in that folder.
6. Restart Alfred if the preferences do not appear immediately.

Alfred expects the `Alfred.alfredpreferences` bundle directly inside the
selected syncing folder, so select `config/alfred/`, not the bundle itself and
not the repository root.
