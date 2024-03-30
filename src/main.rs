use dotenv::dotenv;

fn main() {
    dotenv().ok();
    let name = std::env::var("NAME").expect("NAME must be set.");
    println!("Hello, {name} & world!");
}
