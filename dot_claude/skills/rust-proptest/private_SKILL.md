---
name: rust-proptest
description: Help users write property-based tests in Rust using proptest. Covers strategies, shrinking, composition, and the proptest-derive macro for testing arbitrary inputs.
---

# Rust Proptest Property Testing

This skill helps you write effective property-based tests in Rust using the proptest library. Property testing generates random inputs to verify that certain properties of your code hold for arbitrary inputs.

## When to Use Property Testing

Property testing complements traditional unit testing:
- **Traditional tests**: Specific edge cases, simple inputs, known bugs
- **Property tests**: Complex inputs that expose unexpected problems

Use property testing when you can express invariants about your code's behavior that should hold for all valid inputs.

## Quick Start

### Basic Test Structure

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_name(input in strategy) {
        // Your test assertions here
        prop_assert!(condition);
    }
}
```

### Common Input Strategies

```rust
proptest! {
    #[test]
    fn test_integers(x in 0..100i32) {
        // x is between 0 (inclusive) and 100 (exclusive)
    }

    #[test]
    fn test_strings(s in "[a-z]{1,10}") {
        // s matches the regex: 1-10 lowercase letters
    }

    #[test]
    fn test_arbitrary(data in any::<Vec<String>>()) {
        // data is an arbitrary Vec<String>
    }
}
```

**Reference**: [Getting Started Guide](https://altsysrq.github.io/proptest-book/proptest/getting-started.html)

## Strategy Composition

One of proptest's strengths is composing simple strategies into complex ones.

### Combining Strategies with `prop_map`

Transform a strategy's output to another type:

```rust
use proptest::prelude::*;

// Generate even numbers by transforming any u32
let even_numbers = any::<u32>().prop_map(|x| x / 2 * 2);

// Generate tuples and map to a struct
#[derive(Debug)]
struct Point { x: i32, y: i32 }

let point_strategy = (0..100i32, 0..100i32)
    .prop_map(|(x, y)| Point { x, y });
```

**Prefer `prop_map` over filtering** when possible - it's more efficient and shrinks better.

**Reference**: [Strategy trait documentation](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_map)

### Filtering with `prop_filter`

Use filtering sparingly for rare conditions:

```rust
// Only when you can't express it as a transformation
let non_zero = any::<i32>().prop_filter("non-zero", |x| *x != 0);

// Better approach: combine ranges
let non_zero_better = prop_oneof![
    i32::MIN..0,
    1..=i32::MAX,
];
```

**Warning**: Excessive filtering hurts performance and shrinking quality.

**Reference**: [Strategy::prop_filter](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_filter)

### Flat Mapping for Dependent Values

Use `prop_flat_map` when one value depends on another:

```rust
// Generate a vector and an index into it
let vec_with_index = prop::collection::vec(any::<i32>(), 1..100)
    .prop_flat_map(|vec| {
        let len = vec.len();
        (Just(vec), 0..len)
    });

// Generate a range where end > start
let valid_range = (0..100i32).prop_flat_map(|start| {
    (Just(start), start..100)
});
```

**Reference**: [Strategy::prop_flat_map](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_flat_map)

### Tuple Strategies

Tuples of strategies automatically become strategies for tuples:

```rust
// All fields generated independently
let triple_strategy = (0..10, 100..200, "a|b|c");

proptest! {
    #[test]
    fn test_tuple((a, b, c) in (0..10, 100..200, "a|b|c")) {
        assert!(a < 10);
        assert!(b >= 100);
        assert!(c == "a" || c == "b" || c == "c");
    }
}
```

## Higher-Order Strategies

Higher-order strategies create strategies based on runtime values or combine multiple strategies.

### `prop_oneof!` - Union of Strategies

Select from multiple strategies with optional weights:

```rust
use proptest::prelude::*;

// Equal probability
let mixed_ints = prop_oneof![
    0..10,
    100..200,
    1000..2000,
];

// Weighted - generate small numbers 70% of the time
let mostly_small = prop_oneof![
    7 => 0..10,
    2 => 100..1000,
    1 => 10000..100000,
];
```

**Reference**: [prop_oneof! macro](https://docs.rs/proptest/latest/proptest/macro.prop_oneof.html)

### Collection Strategies

Generate collections with constraints:

```rust
use proptest::collection::*;

// Vec with size range
let small_vecs = vec(any::<i32>(), 0..10);

// HashMap with specific size
let maps = hash_map("[a-z]+", 0..100i32, 5..20);

// Sets with minimum size
let sets = hash_set(any::<String>(), 10..100);

// Fixed-size arrays
let arrays = uniform32(0u8..255);
```

**Reference**: [proptest::collection module](https://docs.rs/proptest/latest/proptest/collection/index.html)

### Recursive Strategies

Use `prop_recursive` for tree-like structures:

```rust
use proptest::prelude::*;

#[derive(Debug, Clone)]
enum Tree {
    Leaf(i32),
    Node(Box<Tree>, Box<Tree>),
}

fn tree_strategy() -> impl Strategy<Value = Tree> {
    let leaf = any::<i32>().prop_map(Tree::Leaf);

    leaf.prop_recursive(
        8,   // max depth
        256, // max nodes
        10,  // items per collection
        |inner| {
            (inner.clone(), inner)
                .prop_map(|(l, r)| Tree::Node(Box::new(l), Box::new(r)))
        }
    )
}
```

**Reference**: [Strategy::prop_recursive](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_recursive)

### `Just` and `LazyJust`

Create strategies for constant or lazily-computed values:

```rust
use proptest::strategy::Just;

// Constant value
let always_42 = Just(42);

// Lazily computed (useful for expensive or non-Clone values)
let lazy_vec = LazyJust::new(|| vec![1, 2, 3, 4, 5]);

// Combine with other strategies
let with_constant = (0..10, Just("constant")).prop_map(|(n, s)| {
    format!("{}: {}", s, n)
});
```

**Reference**: [Just](https://docs.rs/proptest/latest/proptest/strategy/struct.Just.html) and [LazyJust](https://docs.rs/proptest/latest/proptest/strategy/struct.LazyJust.html)

## The `proptest-derive` Macro

The `#[derive(Arbitrary)]` macro automatically generates strategies for custom types.

### Basic Usage

Add to `Cargo.toml`:
```toml
[dev-dependencies]
proptest-derive = "0.2.0"
```

Then derive on your types:

```rust
use proptest_derive::Arbitrary;

#[derive(Debug, Arbitrary)]
struct User {
    name: String,
    age: u8,
    email: String,
}

// Now you can use any::<User>() in tests
proptest! {
    #[test]
    fn test_user(user in any::<User>()) {
        // user is automatically generated
    }
}
```

**Reference**: [proptest-derive guide](https://altsysrq.github.io/proptest-book/proptest-derive/getting-started.html)

### Field-Level Customization

Use `#[proptest(...)]` attributes to customize individual fields:

```rust
#[derive(Debug, Arbitrary)]
struct Config {
    // Custom strategy
    #[proptest(strategy = "1..=100")]
    timeout_seconds: u32,

    // Regex pattern
    #[proptest(regex = "[a-z]{3,10}")]
    name: String,

    // Fixed value
    #[proptest(value = "true")]
    enabled: bool,

    // Filter (use sparingly!)
    #[proptest(filter = "|x| x % 2 == 0")]
    even_number: i32,
}
```

**Reference**: [Modifier reference](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html)

### Enum Strategies

Control variant generation with weights and skip:

```rust
#[derive(Debug, Arbitrary)]
enum Message {
    // Default weight is 1
    Ping,

    // 3x more likely than Ping
    #[proptest(weight = 3)]
    Data(Vec<u8>),

    // Never generate this variant
    #[proptest(skip)]
    Internal(std::fs::File),

    // Custom strategy for whole variant
    #[proptest(strategy = "\"[A-Z][a-z]+\".prop_map(Message::Name)")]
    Name(String),
}
```

**Reference**: [Modifier reference - weight and skip](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html#weight)

### Parameters for Complex Types

Use `params` to parameterize generation:

```rust
#[derive(Debug)]
struct Range(usize, usize);

impl Default for Range {
    fn default() -> Self { Range(0, 100) }
}

#[derive(Debug, Arbitrary)]
#[proptest(params(Range))]
struct DataSet {
    #[proptest(strategy = "params.0..=params.1")]
    size: usize,
    data: Vec<u8>,
}

// Use with any_with
proptest! {
    #[test]
    fn test_dataset(ds in any_with::<DataSet>(Range(10, 50))) {
        assert!(ds.size >= 10 && ds.size <= 50);
    }
}
```

**Reference**: [params modifier](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html#params)

### Common Derive Errors

- **E0001**: Can't derive on types with lifetime parameters (GATs not yet stable)
- **E0008**: Can't skip struct fields - use `#[proptest(value = "expr")]` instead
- **E0025**: Can't use `strategy`, `value`, and `regex` together - pick one

**Reference**: [Error index](https://altsysrq.github.io/proptest-book/proptest-derive/errors.html)

## Common Patterns

### Testing Round-Trip Properties

Verify serialization/deserialization or encoding/decoding:

```rust
proptest! {
    #[test]
    fn roundtrip_json(data in any::<MyData>()) {
        let json = serde_json::to_string(&data)?;
        let decoded: MyData = serde_json::from_str(&json)?;
        prop_assert_eq!(data, decoded);
    }
}
```

### Testing Invariants

Verify properties that should always hold:

```rust
proptest! {
    #[test]
    fn vec_push_increases_length(mut v in any::<Vec<i32>>(), x in any::<i32>()) {
        let old_len = v.len();
        v.push(x);
        prop_assert_eq!(v.len(), old_len + 1);
        prop_assert_eq!(v.last(), Some(&x));
    }
}
```

### Testing Equivalence

Verify two implementations produce the same result:

```rust
proptest! {
    #[test]
    fn optimized_matches_naive(input in any::<Vec<i32>>()) {
        let result1 = naive_implementation(&input);
        let result2 = optimized_implementation(&input);
        prop_assert_eq!(result1, result2);
    }
}
```

### Testing Error Handling

Verify errors occur when expected:

```rust
proptest! {
    #[test]
    fn negative_sqrt_fails(x in i32::MIN..0) {
        prop_assert!(sqrt(x).is_err());
    }
}
```

## Configuration

### Test Case Count and Timeouts

```rust
proptest! {
    #![proptest_config(ProptestConfig {
        cases: 1000,  // Run 1000 test cases (default: 256)
        timeout: 5000,  // Timeout after 5 seconds
        fork: true,  // Run in subprocess (catches panics/infinite loops)
        .. ProptestConfig::default()
    })]

    #[test]
    fn expensive_test(x in 0..1000) {
        // ...
    }
}
```

**Reference**: [Forking and timeouts](https://altsysrq.github.io/proptest-book/proptest/forking.html)

### Failure Persistence

Failed test cases are saved to `proptest-regressions/` directory:

```bash
# Add these to version control!
git add proptest-regressions
```

This ensures failing cases are replayed on future test runs.

**Reference**: [Failure persistence](https://altsysrq.github.io/proptest-book/proptest/failure-persistence.html)

## Key Principles

1. **Prefer transformation over filtering**: Use `prop_map` instead of `prop_filter` when possible
2. **Express constraints in strategies**: Don't generate invalid data then filter it out
3. **Composition is powerful**: Build complex strategies from simple ones
4. **Use derive for custom types**: `#[derive(Arbitrary)]` handles the boilerplate
5. **Shrinking is automatic**: Strategies know how to simplify failing inputs
6. **Add regression tests**: Copy minimal failing inputs to traditional unit tests

## Further Reading

- [Proptest Book](https://altsysrq.github.io/proptest-book/) - Complete guide
- [API Documentation](https://docs.rs/proptest/latest/proptest/) - Full API reference
- [Strategy Trait](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html) - Core strategy methods
- [Differences from QuickCheck](https://altsysrq.github.io/proptest-book/proptest/vs-quickcheck.html) - Why proptest is different
- [Limitations](https://altsysrq.github.io/proptest-book/proptest/limitations.html) - When property testing isn't enough
