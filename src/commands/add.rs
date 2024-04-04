use std::ops::Add;
pub fn run<T: Add<Output = T>>(x: T, y: T) -> T {
    x + y
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_run_pos() {
        assert_eq!(run(2, 3), 5);
    }

    #[test]
    fn test_run_neg() {
        assert_eq!(run(-2, 3), 1);
    }
}
