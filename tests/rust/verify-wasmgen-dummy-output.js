#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import url from "node:url";
import assert from "node:assert/strict";

const __dirname = url.fileURLToPath(new URL(".", import.meta.url));

process.on("unhandledRejection", exn => { throw exn; });

const DUMMY_MODULE_PATH = path.resolve(__dirname, "../../build/dummy_output.wasm");
const dummy_module = fs.readFileSync(DUMMY_MODULE_PATH);

const wm = new WebAssembly.Module(dummy_module);
const mem = new WebAssembly.Memory({ initial: 256 });

// These tests have to be kept in sync with src/rust/wasmgen/module_init.rs' tests
// XXX: make the test more complex, involving locals, conditionals and stuff

let baz_recd_arg;
function baz(arg) {
    baz_recd_arg = arg;
    return 456;
}

let foo_recd_arg;
function foo(arg) {
    foo_recd_arg = arg;
}

const i = new WebAssembly.Instance(wm, { "e": { m: mem, baz, foo } });
i.exports.f();

assert(baz_recd_arg === 2, `baz returned: "${baz_recd_arg}"`);
assert(foo_recd_arg === 456, `foo returned: "${foo_recd_arg}"`);

// The builder test registers branch hints (if_void_unlikely and br_if_likely):
// validate the exact layout of the emitted metadata.code.branch_hint custom section
// against https://github.com/WebAssembly/branch-hinting/blob/main/document/metadata/code/binary.rst —
// engines that parse it (V8, SpiderMonkey, JavaScriptCore) reject/skip malformed sections.
{
    function read_leb_u32(buf, state)
    {
        let result = 0, shift = 0;
        for(;;)
        {
            const byte = buf[state.pos++];
            result |= (byte & 0x7F) << shift;
            if(!(byte & 0x80)) return result >>> 0;
            shift += 7;
        }
    }

    const bytes = dummy_module;
    const sections = [];
    {
        const state = { pos: 8 }; // skip "\0asm" and the wasm version
        while(state.pos < bytes.length)
        {
            const id = bytes[state.pos++];
            const size = read_leb_u32(bytes, state);
            sections.push({ id, start: state.pos, size });
            state.pos += size;
        }
    }

    const is_branch_hint_section = s =>
        s.id === 0 && bytes.subarray(s.start, s.start + s.size).indexOf(0x19) === 0 &&
        Buffer.from(bytes.subarray(s.start + 1, s.start + 26)).toString() === "metadata.code.branch_hint";
    const hint_sections = sections.filter(is_branch_hint_section);
    assert.equal(hint_sections.length, 1, "exactly one metadata.code.branch_hint section");

    const code_section_index = sections.findIndex(s => s.id === 10);
    const hint_section_index = sections.indexOf(hint_sections[0]);
    assert(hint_section_index !== -1 && code_section_index !== -1);
    assert(hint_section_index < code_section_index, "branch hint section must appear before the code section");

    // module has one defined function: funcidx = number of imported functions
    // (the imports are the functions baz, foo; the memory import takes no index)
    const function_index = 2;

    // payload after the section name: vec(function-hint groups), then per group
    // funcidx and vec(hints), each { offset:u32, size:u32 =1, value:u8 (0=unlikely, 1=likely) }
    const state = { pos: hint_sections[0].start + 26 };
    assert.equal(read_leb_u32(bytes, state), 1, "one function-hint group");
    assert.equal(read_leb_u32(bytes, state), function_index, "hint group for the defined function");
    const hint_count = read_leb_u32(bytes, state);
    assert.equal(hint_count, 2, "the test module registers two hints");
    const hints = [];
    for(let h = 0; h < hint_count; h++)
    {
        const offset = read_leb_u32(bytes, state);
        const size = read_leb_u32(bytes, state);
        const value = bytes[state.pos++];
        assert.equal(size, 1, "hint payload size must be 1");
        assert(h === 0 || offset > hints[h - 1].offset, "hint offsets must be strictly increasing");
        hints.push({ offset, value });
    }
    assert(state.pos === hint_sections[0].start + hint_sections[0].size, "no trailing bytes in the branch hint section");

    // the offsets are relative to the beginning of the function body (its locals
    // declarations): they must point at the hinted `if` (0x04) and `br_if` (0x0d) opcodes
    const code = { pos: sections[code_section_index].start };
    assert.equal(read_leb_u32(bytes, code), 1, "one function body");
    const body_size = read_leb_u32(bytes, code);
    const body_start = code.pos;
    assert(body_start + body_size <= bytes.length, "function body within the code section");
    assert.equal(bytes[body_start + hints[0].offset], 0x04, "first hint at the if_void opcode");
    assert.equal(hints[0].value, 0, "if_void_unlikely: likely-false");
    assert.equal(bytes[body_start + hints[1].offset], 0x0D, "second hint at the br_if opcode");
    assert.equal(hints[1].value, 1, "br_if_likely: likely-true");
}
