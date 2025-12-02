---
name: rust-proptest
description: Help users write property-based tests in Rust using proptest. Covers strategies, shrinking, composition, and the proptest-derive macro for testing arbitrary inputs.
---

# Proptest Property-Based Testing Skill

This skill helps you write property-based tests in Rust using the proptest library. Property testing validates that certain properties hold for arbitrary inputs, automatically generating test cases and shrinking failures to minimal examples.

## When to Use This Skill

- Writing property-based tests that check invariants across many inputs
- Creating custom strategies for generating test data
- Composing complex strategies from simpler ones
- Using proptest-derive to generate arbitrary values for custom types
- Debugging shrinking behavior or understanding test failures

## Core Concepts

**Property Testing**: Instead of testing specific inputs, you define properties that should hold for all inputs. Proptest generates random inputs and when a failure occurs, automatically shrinks to the minimal failing case.

**Strategy**: Defines how to generate and shrink values. Strategies are composable building blocks.

**Shrinking**: The process of reducing a failing input to its simplest form while maintaining the failure.

## Basic Setup

Add to `Cargo.toml`:
```toml
[dev-dependencies]
proptest = "1.9.0"
```

For derive support, also add:
```toml
[dev-dependencies]
proptest-derive = "0.2.0"
```

## Quick Start Example

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn parses_all_valid_dates(s in "[0-9]{4}-[0-9]{2}-[0-9]{2}") {
        // Test that all strings matching YYYY-MM-DD format parse successfully
        parse_date(&s).unwrap();
    }

    #[test]
    fn addition_commutative(a in 0..1000i32, b in 0..1000i32) {
        prop_assert_eq!(a + b, b + a);
    }
}
```

**Reference**: [Getting Started Guide](https://altsysrq.github.io/proptest-book/proptest/getting-started.html)

## Built-in Strategies

### Numeric Ranges
```rust
0..100i32           // i32 from 0 to 99
0.0..1.0f64         // f64 from 0.0 to 1.0
any::<u32>()        // Any u32 value
```

### Strings and Regex
```rust
"[a-z]{3,10}"                    // 3-10 lowercase letters
"\\PC*"                          // Any printable characters
string_regex("[0-9]+").unwrap()  // Explicit regex strategy
```

### Collections
```rust
vec(0..100i32, 0..10)            // Vec of 0-9 elements, each 0-99
prop::collection::vec(any::<u8>(), 10..20)  // 10-19 u8 values
prop::collection::hash_set(0..100, 5)       // HashSet with exactly 5 elements
```

### Options and Results
```rust
prop::option::of(0..100i32)      // Option<i32>
prop::result::maybe_ok(0..100, "error")  // Result<i32, &str>
```

**Reference**: [Strategy Documentation](https://docs.rs/proptest/latest/proptest/strategy/index.html)

## Composing Strategies

### Using `prop_map` - Transform Generated Values

```rust
use proptest::prelude::*;

// Generate even numbers by transforming
let even_numbers = any::<i32>().prop_map(|x| x / 2 * 2);

// Generate custom types
#[derive(Debug, Clone)]
struct Point { x: i32, y: i32 }

fn point_strategy() -> impl Strategy<Value = Point> {
    (0..100i32, 0..100i32)
        .prop_map(|(x, y)| Point { x, y })
}
```

### Using `prop_flat_map` - Dependent Strategies

When the second strategy depends on the first value:

```rust
use proptest::prelude::*;

// Generate a vec and an index into it
fn vec_and_index() -> impl Strategy<Value = (Vec<i32>, usize)> {
    prop::collection::vec(any::<i32>(), 1..100)
        .prop_flat_map(|vec| {
            let len = vec.len();
            (Just(vec), 0..len)
        })
}

// Generate ranges where end > start
fn valid_range() -> impl Strategy<Value = (i32, i32)> {
    (0..1000i32).prop_flat_map(|start| {
        (Just(start), start..1000)
    })
}
```

**Reference**: [prop_map docs](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_map), [prop_flat_map docs](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_flat_map)

### Using `prop_filter` - Constrain Values

**Warning**: Filtering is inefficient and interferes with shrinking. Use sparingly.

```rust
use proptest::prelude::*;

// Filter for prime-ish numbers (prefer prop_map when possible)
let filtered = (2..1000u32)
    .prop_filter("not divisible by 2", |x| x % 2 != 0);

// Better approach - generate directly
let odd_numbers = any::<u32>().prop_map(|x| x * 2 + 1);
```

**Reference**: [prop_filter docs](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_filter)

### Using `prop_oneof!` - Choose Between Strategies

```rust
use proptest::prelude::*;

// Generate either small or large numbers (rarely medium)
let bimodal = prop_oneof![
    3 => 0..10i32,      // 30% weight
    7 => 1000..1100,    // 70% weight
];

// Generate different enum variants
fn json_value() -> impl Strategy<Value = JsonValue> {
    prop_oneof![
        any::<i64>().prop_map(JsonValue::Number),
        ".*".prop_map(JsonValue::String),
        Just(JsonValue::Null),
    ]
}
```

**Reference**: [prop_oneof! macro](https://docs.rs/proptest/latest/proptest/macro.prop_oneof.html)

## Compound Strategies - Building Complex Types

### Tuples

Tuples automatically become strategies when all elements are strategies:

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_with_tuple(
        (name, age, active) in ("[a-z]{3,10}", 0..120u8, any::<bool>())
    ) {
        // name is String, age is u8, active is bool
        println!("{} is {} years old, active: {}", name, age, active);
    }
}
```

### Structs with `prop_compose!`

```rust
use proptest::prelude::*;

#[derive(Debug, Clone)]
struct User {
    name: String,
    age: u8,
    email: String,
}

prop_compose! {
    fn user_strategy()
        (name in "[a-z]{3,10}",
         age in 18..100u8,
         domain in "(gmail|yahoo|hotmail)\\.com")
        -> User {
        User {
            name: name.clone(),
            age,
            email: format!("{}@{}", name, domain),
        }
    }
}

proptest! {
    #[test]
    fn test_user(user in user_strategy()) {
        assert!(user.age >= 18);
        assert!(user.email.contains('@'));
    }
}
```

**Reference**: [prop_compose! docs](https://docs.rs/proptest/latest/proptest/macro.prop_compose.html)

### Recursive Strategies

For tree-like structures, use `prop::strategy::LazyJust` and `BoxedStrategy`:

```rust
use proptest::prelude::*;
use proptest::strategy::BoxedStrategy;

#[derive(Debug, Clone)]
enum Tree {
    Leaf(i32),
    Node(Box<Tree>, Box<Tree>),
}

fn tree_strategy() -> BoxedStrategy<Tree> {
    let leaf = any::<i32>().prop_map(Tree::Leaf);

    leaf.prop_recursive(
        8,    // depth
        256,  // max nodes
        10,   // items per collection
        |inner| {
            (inner.clone(), inner)
                .prop_map(|(l, r)| Tree::Node(Box::new(l), Box::new(r)))
        }
    ).boxed()
}
```

**Reference**: [Recursive Strategies](https://docs.rs/proptest/latest/proptest/strategy/trait.Strategy.html#method.prop_recursive)

## Using `proptest-derive`

The derive macro automatically generates `Arbitrary` implementations:

### Basic Derive

```rust
use proptest_derive::Arbitrary;

#[derive(Debug, Arbitrary)]
struct Point {
    x: i32,
    y: i32,
}

// Now can use: any::<Point>()
```

### Modifiers

```rust
use proptest_derive::Arbitrary;

#[derive(Debug, Arbitrary)]
struct Config {
    // Fixed value
    #[proptest(value = "0")]
    counter: u64,

    // Custom strategy
    #[proptest(strategy = "1..100")]
    port: u16,

    // Regex pattern
    #[proptest(regex = "[a-z]{3,10}")]
    name: String,

    // Filter (use sparingly)
    #[proptest(filter = "|x| x % 2 == 0")]
    even_number: u32,
}
```

### Enum Variants

```rust
use proptest_derive::Arbitrary;

#[derive(Debug, Arbitrary)]
enum Message {
    // Skip certain variants
    #[proptest(skip)]
    Internal,

    // Weight variants differently
    #[proptest(weight = 3)]
    Text(String),

    #[proptest(weight = 1)]
    Image { url: String, width: u32, height: u32 },
}
```

### With Parameters

```rust
use proptest_derive::Arbitrary;

#[derive(Debug)]
struct WidgetRange(usize, usize);

impl Default for WidgetRange {
    fn default() -> Self { Self(0, 100) }
}

#[derive(Debug, Arbitrary)]
#[proptest(params(WidgetRange))]
struct WidgetCollection {
    #[proptest(strategy = "params.0..=params.1")]
    count: usize,
}

// Use with: any_with::<WidgetCollection>(WidgetRange(10, 20))
```

**Reference**: [proptest-derive guide](https://altsysrq.github.io/proptest-book/proptest-derive/index.html), [Modifier Reference](https://altsysrq.github.io/proptest-book/proptest-derive/modifiers.html)

## Higher-Order Strategies

### Creating Strategy Factories

```rust
use proptest::prelude::*;

// Function that returns a strategy based on parameters
fn bounded_vec_strategy<T: Strategy>(
    element: T,
    min: usize,
    max: usize
) -> impl Strategy<Value = Vec<T::Value>>
where
    T::Value: std::fmt::Debug,
{
    prop::collection::vec(element, min..=max)
}

// Use it
proptest! {
    #[test]
    fn test_small_vecs(v in bounded_vec_strategy(0..100i32, 0, 5)) {
        assert!(v.len() <= 5);
    }
}
```

### Combining Multiple Strategies

```rust
use proptest::prelude::*;

fn any_collection<T: Strategy>(element: T)
    -> impl Strategy<Value = Collection<T::Value>>
where
    T::Value: std::fmt::Debug + Clone,
{
    prop_oneof![
        prop::collection::vec(element.clone(), 0..10)
            .prop_map(Collection::Vec),
        prop::collection::hash_set(element.clone(), 0..10)
            .prop_map(|s| Collection::Set(s.into_iter().collect())),
        prop::collection::btree_set(element, 0..10)
            .prop_map(|s| Collection::Ordered(s.into_iter().collect())),
    ]
}
```

## Testing Best Practices

### Assertions

Use `prop_assert!` macros instead of `assert!` to get better error messages:

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_properties(x in 0..100i32) {
        prop_assert!(x >= 0);                    // Basic assertion
        prop_assert_eq!(x * 2 / 2, x);          // Equality
        prop_assert_ne!(x, x + 1);              // Inequality
    }
}
```

### Configuration

```rust
use proptest::prelude::*;

proptest! {
    #![proptest_config(ProptestConfig {
        cases: 1000,           // Run 1000 test cases (default: 256)
        max_shrink_iters: 10000,  // More shrinking iterations
        .. ProptestConfig::default()
    })]

    #[test]
    fn expensive_test(x in any::<u32>()) {
        // This test will run 1000 times
    }
}
```

### Forking and Timeouts

For tests that might panic or hang:

```rust
use proptest::prelude::*;

proptest! {
    #![proptest_config(ProptestConfig {
        fork: true,
        timeout: 1000,  // 1 second timeout
        .. ProptestConfig::default()
    })]

    #[test]
    fn potentially_hanging_test(n in 0..100u64) {
        expensive_operation(n);
    }
}
```

**Reference**: [Forking and Timeouts](https://altsysrq.github.io/proptest-book/proptest/forking.html)

## Failure Persistence

Proptest automatically saves failing test cases to `proptest-regressions/` directory:

```bash
# Add to version control
git add proptest-regressions
```

Failed cases are replayed on subsequent test runs before generating new cases. This ensures regressions are caught.

**Reference**: [Failure Persistence](https://altsysrq.github.io/proptest-book/proptest/failure-persistence.html)

## Common Patterns

### Testing Encode/Decode Round-Trips

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn encode_decode_roundtrip(original in any::<MyType>()) {
        let encoded = encode(&original);
        let decoded = decode(&encoded).unwrap();
        prop_assert_eq!(original, decoded);
    }
}
```

### Testing Parser Correctness

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn parse_generated_format(
        (year, month, day) in (0..10000u32, 1..13u32, 1..32u32)
    ) {
        let formatted = format!("{:04}-{:02}-{:02}", year, month, day);
        let (y, m, d) = parse_date(&formatted).unwrap();
        prop_assert_eq!((year, month, day), (y, m, d));
    }
}
```

### Testing Invariants

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn sorted_vec_stays_sorted(mut v in prop::collection::vec(0..1000i32, 0..100)) {
        v.sort();

        // Verify sorted invariant
        for window in v.windows(2) {
            prop_assert!(window[0] <= window[1]);
        }
    }
}
```

## Troubleshooting

### Too Many Rejections

If you see "too many rejections" errors, you're filtering too aggressively. Replace `prop_filter` with `prop_map` or `prop_flat_map`:

```rust
// ❌ Bad: Many rejections
(0..1000u32).prop_filter("even", |x| x % 2 == 0)

// ✅ Good: Generate directly
any::<u32>().prop_map(|x| x * 2)
```

### Shrinking Not Finding Minimal Case

Ensure your strategies compose properly. Each layer should shrink independently. Use `prop_flat_map` when values depend on each other.

### Performance Issues

- Reduce the number of `cases` in config
- Use simpler strategies when possible
- Avoid excessive filtering
- Consider using `prop::sample::select` for choosing from a fixed set

## Additional Resources

- [Proptest Book](https://altsysrq.github.io/proptest-book/)
- [API Documentation](https://docs.rs/proptest/latest/proptest/)
- [Understanding Strategies](https://altsysrq.github.io/proptest-book/proptest/tutorial/index.html)
- [proptest-derive Error Index](https://altsysrq.github.io/proptest-book/proptest-derive/errors.html)
- [Proptest vs QuickCheck](https://altsysrq.github.io/proptest-book/proptest/vs-quickcheck.html)

## Examples Cheatsheet

```rust
// Basic types
any::<i32>()
0..100i32
"[a-z]+"

// Collections
vec(any::<u8>(), 0..10)
hash_set(0..100, 5)

// Transform
any::<i32>().prop_map(|x| x.abs())

// Dependent
vec(any::<i32>(), 1..10).prop_flat_map(|v| (Just(v.clone()), 0..v.len()))

// Filter (avoid)
(0..100).prop_filter("even", |x| x % 2 == 0)

// Choose variants
prop_oneof![0..10, 100..110, 1000..1010]

// Fixed values
Just(42)
prop::option::of(Just("fixed"))

// Derive
#[derive(Arbitrary)]
struct MyType { field: i32 }
```
