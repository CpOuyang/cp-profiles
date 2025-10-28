# Kitty configuration

`kitty.conf` provides the base font and includes `theme.conf` for colours. We vendor upstream themes under `kitty-themes/` so targets can sync without extra network access.

## Themes

- Source: https://github.com/dexpota/kitty-themes (snapshot pulled 2025-09-22).
- Current theme: `Ayu Mirage` (see `theme.conf`).
- To switch themes, update `theme.conf` to include the desired file from `kitty-themes/themes/`.
- To refresh the theme catalogue, mirror upstream changes from the kitty-themes repository and commit the updated files here.
