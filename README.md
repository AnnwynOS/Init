# init

> Experimental first userspace process for Annwyn.

═════════════════════════════════════════════════════════

## ◉ What is init?

`init` is the very first userspace process started by the Annwyn kernel.

It acts as the root of the userspace environment and is responsible for bootstrapping higher-level services.

Current responsibilities include:

✓ Signaling that userspace is alive

✓ Creating core IPC endpoints

✓ Providing the foundation for future services

✓ Remaining alive for the lifetime of the system

Eventually, `init` will become the userspace service manager and process supervisor.

═════════════════════════════════════════════════════════

## ◉ Vision

⟦ ***Userspace Bootstrap*** ⟧

```text
Kernel
   │
   ▼
 init
   │
   ├── log service
   ├── object service
   ├── capability service
   ├── runtime
   └── applications
```

The long-term objective is to move as much functionality as possible out of the kernel and into isolated userspace services.

═════════════════════════════════════════════════════════

## ◉ Project Status

⟦ ***Phase A*** ⟧

The current implementation is intentionally simple.

It currently:

• Announces its startup

• Creates fundamental IPC endpoints

• Enters a permanent loop

This repository is primarily a bootstrap mechanism and will evolve significantly.

═════════════════════════════════════════════════════════

## ◉ Current Progress

### Implemented

* [x] Userspace entry point
* [x] Kernel → userspace transition
* [x] Startup logging
* [x] System endpoint creation
* [x] Log endpoint creation
* [x] Main loop

### In Progress

* [ ] IPC receive loop
* [ ] Message dispatching
* [ ] Service registration

### Planned

* [ ] Service startup
* [ ] SYS_EXEC support
* [ ] Process supervision
* [ ] Restart policies
* [ ] Capability distribution
* [ ] Dependency management

═════════════════════════════════════════════════════════

## ◉ Boot Sequence

⟦ ***Current Flow*** ⟧

```text
Kernel
    ↓
Load init
    ↓
_start()
    ↓
Startup log
    ↓
Create IPC endpoints
    ↓
Main loop
```

Future versions will expand this flow into a complete userspace bootstrap system.

═════════════════════════════════════════════════════════

## ◉ Responsibilities

### Phase A

✓ Signal that userspace is operational

✓ Create fundamental IPC endpoints

✓ Stay alive

---

### Phase B

• Receive service startup requests

• Spawn system services

• Manage process lifecycles

• Distribute capabilities

---

### Long-Term

• Dependency management

• Service supervision

• Restart policies

• System shutdown

• Observability

• Runtime coordination

═════════════════════════════════════════════════════════

## ◉ Entry Point

Unlike traditional applications, `init` has:

• No C runtime

• No standard `main()`

• No libc

• No process above it

Execution begins directly at:

```rust
_start()
```

which is invoked by the kernel after switching to userspace.

═════════════════════════════════════════════════════════

## ◉ Design Philosophy

⟦ ***Keep init Small*** ⟧

`init` should remain primarily an orchestrator.

Responsibilities intentionally excluded:

• Filesystems

• Networking

• Graphics

• Drivers

• Application logic

These belong to dedicated services.

Keeping `init` small improves reliability and simplifies recovery.

═════════════════════════════════════════════════════════

## ◉ Contributing

Contributions, discussions, ideas, criticism, and questions are welcome.

Please keep in mind that:

• Reliability is more important than features.

• Simplicity is preferred over complexity.

• init should remain small.

• Service logic belongs elsewhere.

• Failures should be recoverable whenever possible.

═════════════════════════════════════════════════════════

## ◉ Related Repositories

• annwyn-kernel

• libannwyn

• abo-builder

• annwyn-runtime

• annwyn-docs

═════════════════════════════════════════════════════════

## ◉ License

Licensed under either of:

* MIT License

* Apache License 2.0

at your option.
