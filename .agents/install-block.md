# The canonical install block

One install story, one wording. `README.md`, `.changeset/*`, and every page under `docs/` must say **this** and nothing else. Change it here first, then propagate.

This repo is a fork of `mattpocock/skills`, living at [jhs512/mattpocock-skills](https://github.com/jhs512/mattpocock-skills). Both install routes must name the fork. The upstream plugin listed in **Claude Code's official marketplace** (configured name `claude-plugins-official`) carries the same plugin name, `mattpocock-skills`, so an unqualified install resolves to upstream's build and quietly gets you upstream's skills instead of this fork's. The fork ships through its own marketplace, which is what `.claude-plugin/marketplace.json` is for.

## Claude Code: the plugin

<canonical-block name="claude-code">

```bash
claude plugin marketplace add jhs512/mattpocock-skills
```

```bash
claude plugin install mattpocock-skills@jhs512
```

Or, from inside a session:

```
/plugin marketplace add jhs512/mattpocock-skills
/plugin install mattpocock-skills@jhs512
```

The `@jhs512` suffix is what picks the fork: the plugin name alone is ambiguous once upstream's copy is visible in the official marketplace. Updates are not automatic on a self-hosted marketplace, so pull them when you want them:

```bash
claude plugin marketplace update jhs512 && claude plugin update mattpocock-skills
```

</canonical-block>

## Codex, and other agents: skills.sh

The plugin is Claude Code only. Everywhere else, [skills.sh](https://skills.sh) copies editable skill files into the project. It resolves any public GitHub repo, so the fork's slug works as-is. Use the whole-set form on `README.md`:

<canonical-block name="skills-sh-whole-set">

```bash
npx skills@latest add jhs512/mattpocock-skills
```

Pick the skills you want, and which coding agents to install them on. **The installer lets you choose which skills to take: make sure `setup-matt-pocock-skills` is one of them.**

</canonical-block>

...and the single-skill form wherever one skill is named on its own. Note that **`docs/` pages are not a consumer of this block**: those pages carry no install commands of their own, and a page that writes them out duplicates what belongs here. See [writing-docs.md](./writing-docs.md).

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add jhs512/mattpocock-skills --skill=<name>
```

```bash
npx skills@latest update <name>
```

</canonical-block>

`skills@latest` is the pinned spelling in all three.

**No skills.sh badge or listing page for the fork.** `https://skills.sh/b/jhs512/mattpocock-skills` renders "inaccessible" and the listing page does not resolve: skills.sh indexes registered repos, and the fork is not one. The installer still works, because it reads GitHub directly. Never paste upstream's badge onto this README: it reports upstream's install count, not this fork's.

## The two routes are exclusive

The plugin is a managed, read-only bundle you subscribe to. skills.sh writes files you own and edit. Installing both leaves the user with every skill twice: always say "pick one".

## Not the install story

`claude plugin install mattpocock-skills`, unqualified, is upstream's listing in Claude Code's official marketplace. It installs upstream, not this fork, and is **not** documented to users here. Upstream's own `README.md` documents it as the primary route, so expect it back on every merge from upstream, and resolve in this direction.
