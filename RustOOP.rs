#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Add your functions for lab 8 below. Fuction skeletons with dummy return values 
    are provided, edit them as needed. You may also add additional helper functions. 
    
    Test your code by running 'cargo test' from the lab8 directory.
*/

use std::fmt;
use std::ops;
use std::cmp;

struct Poly {
    coeffs: Vec<i32>,
}

impl ops::Add<Poly> for Poly {
    type Output = Poly;
    fn add(self, other: Poly) -> Poly {
        // Your - code here
        let mut result: Vec<i32> = Vec::new();
        let max_len: usize = self.coeffs.len().max(other.coeffs.len());

        for i in 0..max_len {
            let a = *self.coeffs.get(i).unwrap_or(&0);
            let b = *other.coeffs.get(i).unwrap_or(&0);
            result.push(a + b);
        }

        Poly { coeffs: result }
    }
}
    
impl ops::Sub<Poly> for Poly {
    type Output = Poly;
    fn sub(self, other: Poly) -> Poly {
        // Your - code here
        let mut result: Vec<i32> = Vec::new();
        let max_len: usize = self.coeffs.len().max(other.coeffs.len());

        for i in 0..max_len {
            let a = *self.coeffs.get(i).unwrap_or(&0);
            let b = *other.coeffs.get(i).unwrap_or(&0);
            result.push(a - b);
        }

        Poly { coeffs: result }
    }
}
    
impl cmp::PartialEq for Poly {
    fn eq(&self, other: &Self) -> bool {
        if self.coeffs.len() != other.coeffs.len() {
            return false;
        }

        for i in 0..self.coeffs.len() {
            if self.coeffs[i] != other.coeffs[i] {
                return false;
            }
        }
        
        true
    }
}
    
impl ops::Mul<Poly> for Poly {
    type Output = Poly;
    fn mul(self, other: Poly) -> Poly {
        // Your * code here
        let mut result: Vec<i32> = vec![0; self.coeffs.len() + other.coeffs.len() - 1];

        for i in 0..self.coeffs.len() {
            for j in 0..other.coeffs.len() {
                result[i + j] += self.coeffs[i] * other.coeffs[j];
            }
        }

        Poly { coeffs: result }
    }
}
    
impl ops::Mul<i32> for Poly {
    type Output = Poly;
    fn mul(self, other: i32) -> Poly {

        let mut result: Vec<i32> = vec![1;self.coeffs.len()];

       for i in 0..self.coeffs.len(){
        result[i] = self.coeffs[i]*other;
       }

       Poly{coeffs: result}

    }
}
    
#[cfg(test)]
#[path = "tests.rs"]
mod tests;
