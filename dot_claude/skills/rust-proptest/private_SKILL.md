---
name: rust-proptest
description: Help users write property-based tests in Rust using proptest.
---

# Rust Property Testing with Proptest

This skill helps you write effective property-based tests using the proptest library. Property testing generates random inputs to verify that certain properties of your code hold for all inputs, and automatically shrinks failing cases to minimal reproducible examples.

## Quick Start

Add to `Cargo.toml`:
```toml
[dev-dependencies]
proptest = "1.0.0"
```

Basic test structure:
```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_name(input in strategy) {
        prop_assert!(condition);
    }
}
```

**Reference:** [Getting Started](https://altsysrq.github.io/proptest-book/proptest/getting-started.html)

## Strategy Basics

Strategies define how to generate and shrink test inputs.

**Common built-in strategies:**
```rust
0..100i32                    // Integer range
"[a-z]{3,10}"               // Regex for strings
any::<bool>()               // Any boolean
proptest::collection::vec(strategy, 0..10)  // Vectors
```

**Reference:** [Strategy trait documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html)

## Composing Strategies (Core Focus)

### prop_map - Transform Generated Values

Use `prop_map` to transform one strategy into another:

```rust
// Generate even numbers
any::<u32>().prop_map(|x| x / 2 * 2)

// Generate points from coordinate pairs
(0..100u32, 0..100u32).prop_map(|(x, y)| Point { x, y })

// Generate sorted vectors
proptest::collection::vec(any::<i32>(), 0..20)
    .prop_map(|mut v| { v.sort(); v })
```

**Key principle:** Prefer `prop_map` over `prop_filter` - it's more efficient and shrinks better.

**Reference:** [Strategy::prop_map documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_map)

### prop_flat_map - Dependent Strategies

Use `prop_flat_map` when one strategy depends on the value from another:

```rust
use proptest::strategy::Just;

// Generate a vector, then an index into that vector
proptest::collection::vec(any::<i32>(), 1..10)
    .prop_flat_map(|vec| {
        let len = vec.len();
        (Just(vec), 0..len)
    })

// Generate a string, then a position within it
"[a-z]{1,20}".prop_flat_map(|s| {
    let len = s.len();
    (Just(s), 0..=len)
})

// Generate array size, then array of that size
(1usize..10).prop_flat_map(|size| {
    proptest::collection::vec(any::<u8>(), size..=size)
})
```

**Reference:** [Strategy::prop_flat_map documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_flat_map)

### Combining Multiple Strategies

**Tuples for independent values:**
```rust
// Generate three independent values
(0..100u32, any::<String>(), any::<bool>())

// Then map to a struct
(0..100u32, "\\w{5,15}", any::<bool>())
    .prop_map(|(id, name, active)| User { id, name, active })
```

**prop_oneof! for choosing between strategies:**
```rust
use proptest::strategy::Just;

prop_oneof![
    Just(Color::Red),
    Just(Color::Green),
    Just(Color::Blue),
]

// With different weights
prop_oneof![
    1 => Just(Rarity::Common),
    3 => Just(Rarity::Uncommon),
    5 => Just(Rarity::Rare),
]
```

**Reference:** [prop_oneof! macro](https://docs.rs/proptest/latest/proptest/macro.prop_oneof.html)

### prop_filter - Rejection Sampling

Use sparingly - prefer `prop_map` when possible:

```rust
// ❌ AVOID: Filtering for even numbers
any::<u32>().prop_filter("even", |x| x % 2 == 0)

// ✅ BETTER: Mapping to even numbers
any::<u32>().prop_map(|x| x / 2 * 2)

// ✅ ACCEPTABLE: When mapping isn't feasible
(0..100u32, 0..100u32)
    .prop_filter("distinct coordinates", |(x, y)| x != y)
```

**Reference:** [Strategy::prop_filter documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_filter)

## Higher-Order Strategy Patterns

### Recursive Strategies

For recursive data structures, use `prop::strategy::LazyJust` and boxing:

```rust
use proptest::strategy::{BoxedStrategy, Just, LazyJust};

#[derive(Debug, Clone)]
enum Expr {
    Literal(i32),
    Add(Box<Expr>, Box<Expr>),
    Mul(Box<Expr>, Box<Expr>),
}

fn expr_strategy() -> BoxedStrategy<Expr> {
    let leaf = any::<i32>().prop_map(Expr::Literal);

    leaf.prop_recursive(
        8,   // max depth
        256, // max nodes
        10,  // items per collection
        |inner| {
            prop_oneof![
                (inner.clone(), inner.clone())
                    .prop_map(|(l, r)| Expr::Add(Box::new(l), Box::new(r))),
                (inner.clone(), inner.clone())
                    .prop_map(|(l, r)| Expr::Mul(Box::new(l), Box::new(r))),
            ]
        }
    ).boxed()
}
```

**Reference:** [Strategy::prop_recursive documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_recursive)

### Strategy Functions

Create reusable strategy builders:

```rust
fn bounded_vec_strategy<T: Arbitrary>(
    min_size: usize,
    max_size: usize
) -> impl Strategy<Value = Vec<T::Strategy::Value>>
where
    T::Strategy: 'static
{
    proptest::collection::vec(any::<T>(), min_size..=max_size)
}

fn non_empty_string_strategy() -> impl Strategy<Value = String> {
    "[a-zA-Z0-9]{1,50}"
}

// Usage
proptest! {
    #[test]
    fn test_with_bounded_vec(v in bounded_vec_strategy::<i32>(5, 20)) {
        prop_assert!(v.len() >= 5 && v.len() <= 20);
    }
}
```

### prop_perturb - Value-Dependent Randomization

Use `prop_perturb` when you need access to the RNG:

```rust
// Generate a shuffled version of a specific vector
Just(vec![1, 2, 3, 4, 5])
    .prop_perturb(|mut vec, mut rng| {
        use rand::seq::SliceRandom;
        vec.shuffle(&mut rng);
        vec
    })

// Add random noise to a value
(0.0..100.0f64)
    .prop_perturb(|base, mut rng| {
        use rand::Rng;
        let noise = rng.gen_range(-1.0..1.0);
        base + noise
    })
```

**Reference:** [Strategy::prop_perturb documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_perturb)

## Deriving Arbitrary for Custom Types

Use `proptest-derive` to automatically generate strategies:

```toml
[dev-dependencies]
proptest = "1.0.0"
proptest-derive = "0.2.0"
```

### Basic Usage

```rust
use proptest_derive::Arbitrary;

#[derive(Debug, Clone, Arbitrary)]
struct Person {
    name: String,
    age: u8,
    email: String,
}

// Now you can use any::<Person>()
proptest! {
    #[test]
    fn test_person(person in any::<Person>()) {
        // Test with random Person instances
    }
}
```

**Reference:** [proptest-derive Getting Started](https://altsysrq.github.io/proptest-book/proptest-derive/getting-started.html)

### Custom Strategies with Modifiers

**Field-level strategy customization:**
```rust
#[derive(Debug, Arbitrary)]
struct User {
    #[proptest(strategy = "1..=999999")]
    id: u32,

    #[proptest(regex = "[a-z]{3,20}")]
    username: String,

    #[proptest(strategy = "18..=120u8")]
    age: u8,

    #[proptest(value = "true")]
    active: bool,  // Always true
}
```

**Reference:** [strategy modifier](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html#strategy)

### Enum Variants with Weights

```rust
#[derive(Debug, Arbitrary)]
enum Event {
    #[proptest(weight = 5)]
    Common(u32),

    #[proptest(weight = 2)]
    Uncommon(String),

    #[proptest(weight = 1)]
    Rare { x: i32, y: i32 },

    #[proptest(skip)]
    Impossible,  // Never generated
}
```

**Reference:** [weight modifier](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html#weight)

### Struct-level Filtering

```rust
#[derive(Debug, Arbitrary)]
#[proptest(filter = "|segment| segment.start < segment.end")]
struct Segment {
    start: u32,
    end: u32,
}

// Or use a function
fn is_valid_segment(s: &Segment) -> bool {
    s.start < s.end && s.end - s.start < 1000
}

#[derive(Debug, Arbitrary)]
#[proptest(filter = is_valid_segment)]
struct BoundedSegment {
    start: u32,
    end: u32,
}
```

**Reference:** [filter modifier](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html#filter)

### Custom Parameters

```rust
#[derive(Debug, Default)]
struct WidgetRange(usize, usize);

#[derive(Debug, Arbitrary)]
#[proptest(params(WidgetRange))]
struct WidgetCollection {
    #[proptest(strategy = "params.0..=params.1")]
    count: usize,

    items: Vec<Widget>,
}

// Use with any_with
proptest! {
    #[test]
    fn test_widgets(widgets in any_with::<WidgetCollection>(WidgetRange(10, 50))) {
        prop_assert!(widgets.count >= 10 && widgets.count <= 50);
    }
}
```

**Reference:** [params modifier](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html#params)

## Common Testing Patterns

### Round-trip Testing

```rust
proptest! {
    #[test]
    fn serialize_deserialize_roundtrip(value in any::<MyType>()) {
        let bytes = serialize(&value)?;
        let decoded = deserialize(&bytes)?;
        prop_assert_eq!(value, decoded);
    }
}
```

### Invariant Testing

```rust
proptest! {
    #[test]
    fn sort_preserves_elements(v in proptest::collection::vec(any::<i32>(), 0..100)) {
        let mut sorted = v.clone();
        sorted.sort();

        prop_assert_eq!(v.len(), sorted.len());
        for elem in &v {
            prop_assert!(sorted.contains(elem));
        }
    }
}
```

### Oracle Testing

```rust
proptest! {
    #[test]
    fn optimized_matches_simple(input in any::<Vec<i32>>()) {
        let result1 = optimized_algorithm(&input);
        let result2 = simple_reference_algorithm(&input);
        prop_assert_eq!(result1, result2);
    }
}
```

## Configuration

```rust
proptest! {
    #![proptest_config(ProptestConfig {
        cases: 1000,           // Number of test cases (default: 256)
        max_shrink_iters: 10000,  // Max shrinking iterations
        fork: true,            // Run in subprocess
        timeout: 1000,         // Timeout in milliseconds
        .. ProptestConfig::default()
    })]

    #[test]
    fn my_test(x in 0..100) {
        // test body
    }
}
```

**Reference:** [ProptestConfig documentation](https://docs.rs/proptest/latest/proptest/test_runner/struct.Config.html)

## Best Practices

1. **Prefer composition over filtering**: Use `prop_map` and `prop_flat_map` instead of `prop_filter` when possible
2. **Start with crash testing**: Ensure your code doesn't panic before testing correctness
3. **Use appropriate ranges**: Don't use `any::<i64>()` when `0..1000` is sufficient
4. **Combine with unit tests**: Use property tests for broad coverage, unit tests for specific edge cases
5. **Commit regression files**: Always commit `proptest-regressions/` to version control
6. **Test properties, not implementations**: Focus on what the code should do, not how

## Advanced Features

### Failure Persistence

Proptest automatically saves failing test cases to `proptest-regressions/`:

```bash
git add proptest-regressions
```

Also add failing cases as unit tests:

```rust
#[test]
fn test_specific_failure() {
    assert_eq!(parse_date("0000-10-01"), Some((0, 10, 1)));
}
```

**Reference:** [Failure Persistence](https://altsysrq.github.io/proptest-book/proptest/failure-persistence.html)

### Forking and Timeouts

For tests that might crash or hang:

```rust
proptest! {
    #![proptest_config(ProptestConfig {
        fork: true,
        timeout: 1000,
        .. ProptestConfig::default()
    })]

    #[test]
    fn test_recursive_function(n in 0u64..100) {
        expensive_recursive_function(n);
    }
}
```

**Reference:** [Forking and Timeouts](https://altsysrq.github.io/proptest-book/proptest/forking.html)

## Quick Reference

### Strategy Combinators

| Combinator | Purpose | When to Use |
|------------|---------|-------------|
| `prop_map` | Transform values | Always prefer over filter when possible |
| `prop_flat_map` | Dependent strategies | When one value depends on another |
| `prop_filter` | Reject values | Last resort - inefficient |
| `prop_perturb` | RNG access | Random transformations needing RNG |
| `prop_recursive` | Recursive structures | Trees, nested data structures |
| `prop_union` | Choose strategies | Multiple generation paths |

### Common Strategies

```rust
any::<T>()                                    // Any value of type T
0..100i32                                     // Integer range
"regex"                                       // String matching regex
Just(value)                                   // Always returns value
proptest::collection::vec(strat, size)       // Vector strategy
proptest::collection::hash_set(strat, size)  // HashSet strategy
proptest::option::of(strat)                  // Option strategy
```

## Resources

- **Online Book:** https://altsysrq.github.io/proptest-book/
- **API Documentation:** https://docs.rs/proptest/latest/proptest/
- **proptest-derive Modifiers:** https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html
- **Strategy Trait:** https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html
- **GitHub:** https://github.com/AltSysrq/proptest
