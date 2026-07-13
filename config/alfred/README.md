# Alfred preferences

This folder contains the actual Alfred preferences bundle:

```text
config/alfred/
└── Alfred.alfredpreferences/
```

It is intentionally kept separate from the other configuration categories.
The bundle contains Alfred's preferences, workflows, and related Alfred-managed
configuration files. Alfred only supports choosing the sync folder through its
preferences UI, so this remains a one-time manual setup step.

## Activate these preferences

1. Open **Alfred Preferences** after running setup.
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

Workflow API keys, cookies, and tokens must remain empty in the tracked bundle.
Enter them locally in Alfred and mark those workflow variables as excluded from
export before syncing changes back to this repository.
