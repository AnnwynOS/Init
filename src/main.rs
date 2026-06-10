#![no_std]
#![no_main]

use annwyn::{log, yield_now, exit, endpoint_create, ipc_recv_blocking};

const EP_SYSTEM: u64 = 0;

const MSG_PING: u8 = 0x01;
const MSG_SPAWN_SERVICE: u8 = 0x02;
const MSG_SHUTDOWN: u8 = 0xFF;

#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    log("≺INIT≻ Aster init v0.1\n");

    let ep_system = endpoint_create();
    if ep_system < 0 {
        log("≺INIT≻ FATAL: cannot create system endpoint\n");
        exit(1);
    }
    let ep_system = ep_system as u64;

    let ep_log = endpoint_create();
    if ep_log < 0 {
        log("≺INIT≻ FATAL: cannot create log endpoint\n");
        exit(1);
    }

    log("≺INIT≻ Endpoints ready, entering message loop\n");

    let mut buf = [0u8; 48];

    loop {
        let n = ipc_recv_blocking(0, ep_system, &mut buf);

        if n < 0 {
            yield_now();
            continue;
        }

        if n == 0 { continue; }

        match buf[0] {
            MSG_PING => {
                log("≺INIT≻ PING received\n");
            }
            MSG_SPAWN_SERVICE => {
                log("≺INIT≻ SPAWN_SERVICE request\n");
            }
            MSG_SHUTDOWN => {
                log("≺INIT≻ SHUTDOWN\n");
                exit(0);
            }
            _ => {
            }
        }

        buf = [0u8; 48];
    }
}