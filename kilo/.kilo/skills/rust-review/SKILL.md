---
name: rust-review
description: Use when reviewing Rust projects
---
# Rust Code Review

## Scope

Review the Rust project code for correctness, safety, concurrency, performance, and API
quality.

Split the work into multiple sub-agents either by crate, dimensions or both in large
projects.

## Gates (run before reading code)

- `cargo fmt --check`
- `cargo clippy --all-targets --all-features -- -D warnings`
- `cargo test`

Report gate failures verbatim; do not fix them silently.

## Review dimensions

### 1. Correctness

- `unwrap` / `expect` / `panic!` / `unreachable!` in library paths (acceptable in bins
  only at startup or with justification)
- Integer casts (`as`), float equality, division by zero, off-by-one in indexing
- Wrong pattern binding, `match` on references (match ergonomics), shadowed variables
- Drop order, RAII guard misuse, early return vs. deferred cleanup
- `#[must_use]` missing on fallible constructors and pure functions

### 2. Safety (unsafe)

- Every `unsafe` block REQUIRES a `// SAFETY:` comment stating the invariants
- Raw pointer derefs: alignment, lifetime, null checks and provenance
- `unsafe impl Send/Sync` must be justified or removed
- Prefer safe abstractions (`NonZero*`, `get_unchecked` only with proof, `Bytes`) over
  hand-written unsafe use established libraries when available
- FFI boundaries: nul-terminated strings, error code translation, ownership transfer

### 3. Ownership and lifetimes

- Unnecessary `.clone()`, borrow conflicts from over-long borrows
- Self-referential structs, `'static` over-constraints that force `Arc` cloning
- Returning references when callers need owned data
- Iterator invalidation patterns, `mem::swap`/`replace` correctness

### 4. Concurrency

- Mutex guards held across `.await`
- Atomics: ordering (`Relaxed` misuse), lost updates, `Arc<Mutex>` contention
- Task spawn lifetimes: `'static` captures hiding borrowed data
- Deadlock ordering, lock granularity, re-entrancy issues

### 5. Async

- `.await` inside non-`Send` futures, blocking I/O on async runtimes
- `std::sync::Mutex` vs `tokio::sync::Mutex` choice when guarding across await
- Cancel-safety of streams, sockets, and transactions
- Unbounded channels / missing backpressure, `select!` fairness

### 6. Performance

- Hidden allocations: `to_string`/`format!` in loops, `collect`-then-iterate
- `.clone()` vs borrow in hot paths; `impl AsRef<str>` vs `String` parameters
- Iterator chain pitfalls (nested `filter_map`, missing `size_hint`)
- `Vec` growth: `with_capacity` where size is known
- `Cow`, `SmallVec`, `Box<str>` where appropriate

### 7. Error handling

- Libraries: `thiserror` typed errors; binaries: `eyre` with `.context()`
- Error conversion (`?` with `From`) vs stringifying

### 8. API and idioms

- Clippy pedantic: `map` vs `and_then`, `ok_or_else`, `is_some_and`, `copied`
- Naming conventions: `iter`/`iter_mut`/`into_iter`, `new` vs `with_capacity`
- Derive `Debug` whenever possible
- Do not re-invent features from the Rust stdlib or readily available ecosystem crates
- Use `tracing` for logging

### 9. Tests and docs

- No `#[ignore]`d tests without a tracking reason
- `cfg(test)` modules

### 10. Project specific

- Any violations of local rules established by `AGENTS.md` instructions or equivalent
  sources

## Output format

```
## Issues Found

| Severity | File:Line | Issue |
|---|---|---|
| CRITICAL | path/file.rs:42 | Brief description |
| WARNING | path/file.rs:78 | Brief description |
| SUGGESTION | path/file.rs:15 | Brief description |

If no issues found: "No issues found."

## Detailed Findings

Repeat the block below once for each issue listed in the table above, in the same order
and numbered to match its table row. Separate consecutive findings with a blank line.
Put the severity from the table in brackets in the heading so the two sections
cross-reference.

### 1. [CRITICAL] `path/to/file.rs:line`: Short title from the table

**Problem:** What's wrong and why it matters.

**Suggestion:** Recommended fix with code snippet if applicable.

### 2. [WARNING] `path/to/file.rs:line`: Short title from the table

**Problem:** What's wrong and why it matters.

**Suggestion:** Recommended fix with code snippet if applicable.

If no issues found: "No detailed findings."
```

## Rules

- Mark style-only as `SUGGESTIONS`; do not demand rewrites of working code.
- Cite the rule source (clippy lint name, Rust API guideline, Rustonomicon) when known.
- Distinguish "this is wrong" from "this could be more idiomatic".
- Never invent APIs or crate names; verify against docs before citing.
- If unsafe code is present and gates are not runnable, say so explicitly instead of
  implying a clean bill of health.
- More local rules from `AGENTS.md` take precedence
