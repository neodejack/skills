some skills for agents

to list the skills:

```sh
npx skills add neodejack/skills --list
```

to install the skills:

```sh
npx skills add neodejack/skills
```

## developing

symlink skills into `~/.agents/skills` for live editing:

```sh
just dev-setup
```

when done, restore the original installs:

```sh
just dev-teardown
```
