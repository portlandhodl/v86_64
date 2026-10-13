#!/usr/bin/env node
// Cross-module chaining probe: runs chain32.asm (9 pages, round-robin calls)
// with the profiler build and a low hotness threshold. With chaining on,
// nearly every call/ret is a tail call between modules, so RUN_FROM_CACHE
// (module entries, incl. chained ones) is far above CYCLE_INTERNAL dispatches.
// Arg "off" disables 32-bit chaining (JIT32_CHAINING=0).
import url from "node:url";
import path from "node:path";
import { execFileSync } from "node:child_process";

const __dirname = url.fileURLToPath(new URL(".", import.meta.url));
const root_path = path.join(__dirname, "..", "..");

const { V86 } = await import(root_path + "/src/main.js");

const chaining_off = process.argv[2] === "off";

const bin_file = path.join(__dirname, "chain32.bin");
execFileSync("nasm", ["-w+error", "-f", "bin", "-o", bin_file, path.join(__dirname, "chain32.asm")]);

const emulator = new V86({
    wasm_path: root_path + "/build/v86.wasm",
    bios: { url: bin_file },
    autostart: true,
    memory_size: 64 * 1024 * 1024,
    log_level: 0,
});

// compile hot code quickly (as in the longmode JIT_THRESHOLD=1 runs)
emulator.bus.register("emulator-started", () => {
    emulator.v86.cpu.wm.exports["set_jit_config"](5, 2000);
    if(chaining_off)
    {
        emulator.v86.cpu.wm.exports["set_jit_config"](10, 0);
    }
});
let start;
emulator.bus.register("emulator-started", () => { start = performance.now(); });
emulator.add_listener("serial0-output-byte", byte => {
    if(byte !== 0x4B) return; // 'K'
    // read the counters only once the guest has halted
    setTimeout(() => {
        const e = emulator.v86.cpu.wm.exports;
        const stat = i => Number(e["profiler_stat_get"](i));
        const instructions = Number(emulator.get_instruction_counter());
        const interpreted = stat(13);
        const cache_entries = stat(25);
        const jit_steps = stat(26);
        const elapsed = performance.now() - start;
        const out = {
            chaining_32: chaining_off ? "off" : "on",
            elapsed_ms: +elapsed.toFixed(0),
            mips_32: +(instructions / elapsed / 1000).toFixed(1),
            instructions,
            RUN_INTERPRETED: interpreted,
            RUN_FROM_CACHE: cache_entries,
            RUN_FROM_CACHE_STEPS: jit_steps,
            INDIRECT_JUMP: stat(28),
            INDIRECT_JUMP_NO_ENTRY: stat(29),
            CYCLE_INTERNAL: stat(76),
        };
        out.chained_module_entries = cache_entries - (stat(76) - interpreted);
        const mem = emulator.read_memory(0x508, 4);
        out.counter = new Uint32Array(mem.buffer, mem.byteOffset, 1)[0];
        console.log(JSON.stringify(out));
        emulator.destroy();
        process.exit(0);
    }, 500);
});
