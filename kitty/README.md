# Kitty configuration

`kitty.conf` provides the base font and includes `theme.conf` for colours. We vendor upstream themes under `kitty-themes/` so targets can sync without extra network access.

## Themes

- Source: https://github.com/dexpota/kitty-themes (snapshot pulled 2025-11-28).
- Current theme: `Night Owl` (see `theme.conf`; bright text #d6deeb on deep #011627, selection #1d3b53 with light fg for high contrast).
- To switch themes, update `theme.conf` to include the desired file from `kitty-themes/themes/`.
- To refresh the theme catalogue, mirror upstream changes from the kitty-themes repository and commit the updated files here.
