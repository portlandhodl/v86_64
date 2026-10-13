(module
  (type $t0 (func))
  (type $t1 (func (param i32)))
  (type $t2 (func (param i32 i32)))
  (type $t3 (func (param i32 i32 i32)))
  (type $t4 (func (result i32)))
  (type $t5 (func (result i64)))
  (type $t6 (func (param i32) (result i32)))
  (type $t7 (func (param i32 i32) (result i32)))
  (type $t8 (func (param i32) (result i64)))
  (type $t9 (func (param f32) (result i32)))
  (type $t10 (func (param f64) (result i32)))
  (type $t11 (func (param i32 i64)))
  (type $t12 (func (param i64 i32)))
  (type $t13 (func (param i64 i32) (result i32)))
  (type $t14 (func (param i64 i32) (result i64)))
  (type $t15 (func (param i32 i32 i32) (result i32)))
  (type $t16 (func (param i64 i32 i32)))
  (type $t17 (func (param i32 i64 i32)))
  (type $t18 (func (param i32 i64 i32) (result i32)))
  (type $t19 (func (param i32 i64 i64 i32) (result i32)))
  (type $t20 (func (param i64)))
  (type $t21 (func (param i64 i64)))
  (type $t22 (func (param i32 i32 i64)))
  (type $t23 (func (param i32 i32 i32 i32) (result i32)))
  (type $t24 (func (param i32 i32 i32 i32 i32) (result i32)))
  (type $t25 (func (param i32 i32 i64) (result i32)))
  (type $t26 (func (param i32 i32 i64 i32) (result i32)))
  (type $t27 (func (param i32 i32 i64 i32 i32) (result i32)))
  (type $t28 (func (param i64 i32 i32) (result i32)))
  (type $t29 (func (param i64 i64 i32) (result i32)))
  (type $t30 (func (param i64 i64) (result i64)))
  (type $t31 (func (param i32 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)))
  (type $t32 (func (param i32 i32 i32 i32 i32 i32 i32 i32 i32)))
  (import "e" "instr_F4" (func $e.instr_F4 (type $t0)))
  (import "e" "exit_jit" (func $e.exit_jit (type $t0)))
  (import "e" "m" (memory {normalised output}))
  (func $f (export "f") (type $t32) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (param $p6 i32) (param $p7 i32) (param $p8 i32)
    (local $l0 i32) (local $l1 i32)
    (set_local $l0
      (i32.const 0))
    (block $B0
      (block $B1
        (loop $L2
          (br_if $B0
            (i32.ge_u
              (get_local $l0)
              (i32.const 100003)))
          (block $B3
            (block $B4
            )
            (block $B5
              (set_local $l0
                (i32.add
                  (get_local $l0)
                  (i32.const 1)))
              (br_if $B5
                (if $I6 (result i32)
                  (i32.and
                    (i32.load
                      (i32.const 100))
                    (i32.const 64))
                  (then
                    (i32.and
                      (i32.shr_u
                        (i32.and
                          (i32.xor
                            (tee_local $l1
                              (i32.load
                                (i32.const 112)))
                            (i32.const -1))
                          (i32.sub
                            (get_local $l1)
                            (i32.const 1)))
                        (i32.load
                          (i32.const 96)))
                      (i32.const 1)))
                  (else
                    (i32.and
                      (i32.load
                        (i32.const 120))
                      (i32.const 64)))))
              (set_local $l0
                (i32.add
                  (get_local $l0)
                  (i32.const 1)))
              (i32.store
                (i32.const 104)
                (get_local $p1))
              (set_local $p1
                (i32.add
                  (get_local $p1)
                  (get_local $p1)))
              (i32.store
                (i32.const 112)
                (get_local $p1))
              (i64.store
                (i32.const 96)
                (i64.const 9710921056287)))
            (set_local $l0
              (i32.add
                (get_local $l0)
                (i32.const 2)))
            (i32.store
              (i32.const 104)
              (get_local $p4))
            (set_local $p4
              (i32.add
                (get_local $p4)
                (get_local $p4)))
            (i32.store
              (i32.const 112)
              (get_local $p4))
            (i64.store
              (i32.const 96)
              (i64.const 9710921056287))
            (i32.store
              (i32.const 264)
              (i32.or
                (i32.and
                  (i32.load
                    (i32.const 256))
                  (i32.const -4096))
                (i32.const 6)))
            (i32.store
              (i32.const 256)
              (i32.or
                (i32.and
                  (i32.load
                    (i32.const 256))
                  (i32.const -4096))
                (i32.const 7)))
            (i32.store
              (i32.const 128)
              (get_local $p1))
            (i32.store
              (i32.const 136)
              (get_local $p2))
            (i32.store
              (i32.const 144)
              (get_local $p3))
            (i32.store
              (i32.const 152)
              (get_local $p4))
            (i32.store
              (i32.const 160)
              (get_local $p5))
            (i32.store
              (i32.const 168)
              (get_local $p6))
            (i32.store
              (i32.const 176)
              (get_local $p7))
            (i32.store
              (i32.const 184)
              (get_local $p8))
            (call $e.instr_F4)
            (set_local $p1
              (i32.load
                (i32.const 128)))
            (set_local $p2
              (i32.load
                (i32.const 136)))
            (set_local $p3
              (i32.load
                (i32.const 144)))
            (set_local $p4
              (i32.load
                (i32.const 152)))
            (set_local $p5
              (i32.load
                (i32.const 160)))
            (set_local $p6
              (i32.load
                (i32.const 168)))
            (set_local $p7
              (i32.load
                (i32.const 176)))
            (set_local $p8
              (i32.load
                (i32.const 184)))
            (br $B0))
          (unreachable)))
      (i32.store
        (i32.const 128)
        (get_local $p1))
      (i32.store
        (i32.const 136)
        (get_local $p2))
      (i32.store
        (i32.const 144)
        (get_local $p3))
      (i32.store
        (i32.const 152)
        (get_local $p4))
      (i32.store
        (i32.const 160)
        (get_local $p5))
      (i32.store
        (i32.const 168)
        (get_local $p6))
      (i32.store
        (i32.const 176)
        (get_local $p7))
      (i32.store
        (i32.const 184)
        (get_local $p8))
      (call $e.exit_jit)
      (i32.store
        (i32.const 664)
        (i32.add
          (i32.load
            (i32.const 664))
          (get_local $l0)))
      (return))
    (i32.store
      (i32.const 128)
      (get_local $p1))
    (i32.store
      (i32.const 136)
      (get_local $p2))
    (i32.store
      (i32.const 144)
      (get_local $p3))
    (i32.store
      (i32.const 152)
      (get_local $p4))
    (i32.store
      (i32.const 160)
      (get_local $p5))
    (i32.store
      (i32.const 168)
      (get_local $p6))
    (i32.store
      (i32.const 176)
      (get_local $p7))
    (i32.store
      (i32.const 184)
      (get_local $p8))
    (i32.store
      (i32.const 664)
      (i32.add
        (i32.load
          (i32.const 664))
        (get_local $l0)))))
