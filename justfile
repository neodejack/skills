set quiet := true

skills_dir := justfile_directory() / "skills"
agents_dir := env_var('HOME') / ".agents" / "skills"

# list available recipes
[default]
list:
    @just --list --list-heading $'just what?\n' --list-prefix '~> '

# symlink repo skills into ~/.agents/skills for live development
dev-setup:
    hack/dev-setup.sh "{{ skills_dir }}" "{{ agents_dir }}"

# remove dev symlinks and restore backed-up skills
dev-teardown:
    hack/dev-teardown.sh "{{ skills_dir }}" "{{ agents_dir }}"
