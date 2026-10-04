# SYNTAX.md fixtures

Golden files copied from [SYNTAX.md](../SYNTAX.md). They are the regression test of the guide: when the rulesets
move, these files must still pass.

- `contributte/` (dialect A): `make install && make qa && make tests` — phpcs with `contributte/qa`, phpstan level 9
  with `contributte/phpstan`, Nette Tester via `contributte/tester`. The DI extension, its supporting stubs and the
  test are the examples from SYNTAX.md sections 2.10, 2.11 and 2.14.
- `nette/` (dialect B): `make install && make cs` — DressCode with the `nette` preset (the standard
  `nette/coding-standard` 4.0-dev wraps). The files are the examples from SYNTAX.md sections 3.2, 3.3 and 3.13.

Both directories were green on 2026-09-29. Keep them in sync with the guide: edit the guide first, then copy the
block here.
