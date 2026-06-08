#![no_std]
#![no_main]
#![feature(naked_functions)]
use annwyn::{log, yield_now, exit, endpoint_create};

#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    log("≺INIT≻ Annwyn init started\n");

    let ep_system = endpoint_create();
    if ep_system < 0 {
        log("≺INIT≻ ERROR: failed to create system endpoint\n");
        exit(1);
    }
    log("≺INIT≻ System endpoint created\n");

    let ep_log = endpoint_create();
    if ep_log < 0 {
        log("≺INIT≻ ERROR: failed to create log endpoint\n");
        exit(1);
    }
    log("≺INIT≻ Log endpoint created\n");

    log("≺INIT≻ Entering main loop\n");

    loop {
        yield_now();
    }
}