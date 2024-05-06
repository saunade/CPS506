#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Add your functions for lab 7 below. Fuction skeletons with dummy return values 
    are provided, edit them as needed. You may also add additional helper functions. 
    
    Test your code by running 'cargo test' from the lab7 directory.
*/

fn count_peaks(items: &[i32]) -> u32
{
    let mut count = 0;
    let n = items.len();

    if n == 0 {
        return 0;
    } else if n==1 || items[0] > items[1]{
        count += 1;
    }

    if items[n-1] > items[n-2]{
        count += 1;
    }

    for i in 1..(n-1) {
        if items[i] > items[i+1] && items[1] > items[i-1]{
            count +=1;
        }
    }

    count
}
    
fn remove_runs(items: &[i32]) -> Vec<i64> 
{
    let mut vec: Vec<i64> = Vec::new();
    for n in items {
        vec.push(*n as i64);
    }
    vec.dedup();
    vec
}

fn count_and_remove_primes(items: &mut [u32]) -> u32
{
    let mut count = 0;

    for i in 0..items.len() {
        if is_prime(items[i]){
            items[i] = 0;
            count += 1;            
        }
    }
    count
}

fn is_prime(num: u32) -> bool
{
    if num <= 1 {
        return false;
    }

    for i in 2..num{
        if num%i == 0{
            return false;
        }
    }
    true

}

fn safe_squares_rooks(n: u8, rooks: &[(u8, u8)]) -> u32
{
    let mut board: Vec<(u8,u8)> = Vec::new();
    let mut safe: u32 = (n as u32)*(n as u32);
    let mut x = 0;

    for i in rooks {
        let (x,y) = i;

        for j in 0..n{
            if !board.contains(&(*x,j)){
                board.push((*x, j));
            }

            if !board.contains(&(j,*y)){
                board.push((j, *y));
            }
        }

    }
    x = board.len();
    safe = safe - (x as u32);
    safe
}

#[cfg(test)]
#[path = "tests.rs"]
mod tests;
