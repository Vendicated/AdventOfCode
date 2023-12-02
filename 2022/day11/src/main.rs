use regex::Regex;
use std::{collections::VecDeque, env::args, fs};

const OP_OLD: usize = 0;

#[derive(Debug)]
enum Op {
    Add,
    Mul,
}

#[derive(Debug)]
struct Monkey {
    items: VecDeque<usize>,
    op: Op,
    op_n: usize,
    divisable_by: usize,
    if_true: usize,
    if_false: usize,

    inspect_count: usize,
}

fn to_usize<'t>(group: Option<regex::Match<'t>>) -> usize {
    group.unwrap().as_str().parse::<usize>().unwrap()
}

fn main() {
    let mut argv = args().skip(1).collect::<VecDeque<String>>();
    let part = argv.pop_front().unwrap();

    let re = Regex::new(
        r"(?x)
Monkey\s(?P<monkey_id>\d+):
\n\s+
Starting\sitems:\s(?P<items>(\d+,\s)*\d+)
\n\s+
Operation:\snew\s=\sold\s(?P<op>\*|\+)\s(?P<op_n>\d+|old)
\n\s+
Test:\sdivisible\sby\s(?P<div>\d+)
\n\s+
If\strue:\sthrow\sto\smonkey\s(?P<if_true>\d+)
\n\s+
If\sfalse:\sthrow\sto\smonkey\s(?P<if_false>\d+)
",
    )
    .unwrap();

    for file in &argv {
        let mut monkeys = Vec::<Monkey>::new();

        // read file as string
        let str = fs::read_to_string(file.to_owned()).unwrap();

        for m in re.captures_iter(str.as_str()) {
            let monke = Monkey {
                items: m
                    .name("items")
                    .unwrap()
                    .as_str()
                    .split(", ")
                    .map(|x| x.parse::<usize>().unwrap())
                    .collect(),
                op: if m.name("op").unwrap().as_str() == "*" {
                    Op::Mul
                } else {
                    Op::Add
                },
                op_n: m
                    .name("op_n")
                    .unwrap()
                    .as_str()
                    .parse::<usize>()
                    .unwrap_or(OP_OLD),
                divisable_by: to_usize(m.name("div")),
                if_true: to_usize(m.name("if_true")),
                if_false: to_usize(m.name("if_false")),
                inspect_count: 0,
            };
            monkeys.push(monke);
        }

        let divisor: usize = monkeys.iter().fold(1, |x, y| x * y.divisable_by);

        let n = if part == "2" { 10000 } else { 20 };
        for _ in 0..n {
            for i in 0..monkeys.len() {
                while let Some(item) = monkeys[i].items.pop_front() {
                    monkeys[i].inspect_count += 1;
                    let n = match monkeys[i].op_n {
                        OP_OLD => item,
                        _ => monkeys[i].op_n,
                    };
                    let mut worry_level = match monkeys[i].op {
                        Op::Add => item + n,
                        Op::Mul => item * n,
                    };
                    if part == "1" {
                        worry_level /= 3;
                    } else {
                        worry_level %= divisor;
                    }

                    let next_monkey = match worry_level % monkeys[i].divisable_by {
                        0 => monkeys[i].if_true,
                        _ => monkeys[i].if_false,
                    };
                    monkeys[next_monkey].items.push_back(worry_level)
                }
            }
        }

        let mut monkey_business = monkeys
            .iter()
            .map(|x| x.inspect_count)
            .collect::<Vec<usize>>();
        monkey_business.sort_unstable();
        monkey_business.reverse();
        println!(
            "{} ~ Part {}: {:?}",
            file,
            part,
            monkey_business[0] * monkey_business[1]
        );
    }
}
