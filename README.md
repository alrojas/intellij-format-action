# IntelliJ IDEA formatter action

Runs the formatter on code to auto-fix style, or enforce it.

## Inputs

### `include-glob`

Pattern for files to include in the formatting, e.g. `*.java,*.kt`. Default: `*`.

### `fail-on-changes`

Causes the action to fail upon detecting files changed by running the formatter if set to `true`.
Default: `false`.

### `files`

List of files in Pull Request. Must be relative to the workspace.
Default: `.`.

## Outputs

### `files-changed`

Zero if none changed, greater if at least one file changed.

## Example usage

```yaml
uses: alrojas/intellij-format-action@master
with:
  include-glob: '*.kt,*.java'
  files: com/example/class.java
```