# Submitting xroar to conda-forge

`recipe.yaml` here is the recipe for
[conda-forge/staged-recipes](https://github.com/conda-forge/staged-recipes).
It passes `conda-smithy recipe-lint --conda-forge`, and builds and passes its
tests with staged-recipes' `build-locally.py linux64` (conda-forge's
`linux-anvil` image), as of conda-smithy 2026.9.23 and rattler-build 0.76.1.

## Steps

1. Fork and clone staged-recipes, and branch:

   ```sh
   gh repo fork conda-forge/staged-recipes --clone=false
   git clone git@github.com:klp2/staged-recipes.git ~/code/staged-recipes
   cd ~/code/staged-recipes
   git remote add upstream https://github.com/conda-forge/staged-recipes.git
   git switch -c add-xroar
   ```

2. Add the recipe:

   ```sh
   mkdir recipes/xroar
   cp ~/code/xroar-builds/conda-forge/recipe.yaml recipes/xroar/
   ```

3. Optional, but it saves a CI round trip: lint and build. These work with mise
   and podman (no conda or Docker install needed):

   ```sh
   mise x conda:conda-smithy@latest -- conda-smithy recipe-lint --conda-forge recipes/xroar
   ```

   `build-locally.py` calls `docker` and passes `-it`, so give it a `docker`
   that runs podman without `-it`, and map your UID into the container:

   ```sh
   mkdir -p /tmp/podman-shim
   printf '#!/bin/bash\nargs=()\nfor a in "$@"; do [[ $a == -it ]] || args+=("$a"); done\nexec podman "${args[@]}"\n' >/tmp/podman-shim/docker
   chmod +x /tmp/podman-shim/docker
   PATH=/tmp/podman-shim:$PATH \
     CONDA_FORGE_DOCKER_RUN_ARGS="--security-opt label=disable --userns=keep-id --user 0" \
     python3 build-locally.py linux64
   ```

   The package lands in `build_artifacts/linux-64/`. Don't commit
   `build_artifacts/`.

4. Commit, push, and open the PR:

   ```sh
   git add recipes/xroar
   git commit -m "Add xroar"
   git push origin add-xroar
   gh pr create --repo conda-forge/staged-recipes --head klp2:add-xroar \
     --title "Add xroar" --body-file ~/code/xroar-builds/conda-forge/pr-body.md
   ```

5. On the PR, post the maintainer confirmation the checklist asks for, as a
   comment of its own:

   > I am willing to be listed as a maintainer of this recipe.

6. When CI is green, ask for review. First-time contributors can't mention
   conda-forge teams, so use the bot:

   > @conda-forge-admin, please ping team

   Review is by volunteers and can take days or weeks. If it stalls, ask on
   [Zulip](https://conda-forge.zulipchat.com).

7. Address review comments by pushing to the same branch. If CI fails for
   reasons outside the recipe, rebase on upstream `main` and force-push.

## After it merges

- conda-forge creates `conda-forge/xroar-feedstock` and invites you to its
  maintainer team (watch for the email). You then merge the bots' version-bump
  PRs and answer issues there.
- In dot-files, replace the `github:klp2/xroar-builds` entry in
  `config/mise/mise.personal.toml` with `"conda:xroar" = "latest"`, then
  archive this repository.
