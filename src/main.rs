use clap::{Arg, Command};
use rust_boilerplate::commands;

fn main() {
    let matches = Command::new("CLI Program")
        .version("1.0")
        .author("Your Name")
        .about("A simple CLI program using clap")
        .subcommand(
            Command::new("hello").about("Prints 'Hello, World!'").arg(
                Arg::new("name")
                    .short('n')
                    .long("name")
                    .value_name("NAME")
                    .default_value("World")
                    .help("Sets a custom name"),
            ),
        )
        .subcommand(Command::new("goodbye").about("Prints 'Goodbye!'"))
        .subcommand(
            Command::new("add")
                .about("Adds two numbers and prints result")
                .arg(Arg::new("x").index(1).help("The first number"))
                .arg(Arg::new("y").index(2).help("The second number")),
        )
        .get_matches();

    match matches.subcommand() {
        Some(("hello", sub_m)) => {
            let name = sub_m.get_one::<String>("name").expect("name is required");
            commands::hello::run(name);
        }
        Some(("goodbye", _)) => {
            commands::goodbye::run();
        }
        Some(("add", sub_m)) => {
            let x: i32 = sub_m
                .get_one::<String>("x")
                .expect("x is required")
                .parse()
                .expect("x must be a number");
            let y: i32 = sub_m
                .get_one::<String>("y")
                .expect("y is required")
                .parse()
                .expect("y must be a number");

            println!("The result is {}", commands::add::run(x, y));
        }
        _ => println!("No subcommand provided"),
    }
}
