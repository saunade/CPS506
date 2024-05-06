//sanna balouchi
#![allow(non_snake_case,non_camel_case_types,dead_code)]

use std::collections::{HashMap, HashSet, VecDeque};

//build tree struct to find if word is a prefix, wastes less time in dfs
struct Trie { children: HashMap<char, Trie>, end_of_word: Option<bool> }

impl Trie {
    fn new() -> Self { 
        Trie { 
            children: HashMap::new(), end_of_word: None 
        } 
    }

    fn insert(&mut self, word: &str) { 
        let mut node = self; 
        for ch in word.chars() { 
            node = node.children.entry(ch).or_insert(Trie::new()); 
        } 
        node.end_of_word = Some(true); 
    }

    fn search(&self, word: &str) -> bool { 
        let mut node = self; 
        for ch in word.chars() { 
            match node.children.get(&ch) { 
                Some(n) => node = n, None => return false, 
            } 
        } 
        node.end_of_word.is_some() 
    }

    fn starts_with(&self, prefix: &str) -> bool { 
        let mut node = self; 
        for ch in prefix.chars() { 
            match node.children.get(&ch) { 
                Some(n) => node = n, None => return false, 
            } 
        } 
        true 
    }
}

fn boggle(board: & [&str], words: & Vec<String>) -> HashMap<String, Vec<(u8, u8)>> {
    //creating found hashmap
    let mut found: HashMap<String, Vec<(u8, u8)>> = HashMap::new();
    
    //creating prefix
    let mut trie = Trie::new(); 
    for word in words { trie.insert(word); }

    //creating board parameters
    let n = board.len(); 
    let directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];

    //applying dfs to all letters on board
    for x in 0..n { 
        for y in 0..n { 
            dfs(board, &trie, (x as u8, y as u8), &directions, &mut VecDeque::new(), &mut HashSet::new(), &mut VecDeque::new(), &mut found); 
        } 
    }
    
    found
}

/** 
 * parameters: board, trie, directions/neighbours, path, visited, coords, found
 * path = characters creating current word once .iter().collect() is applied
 * visited = keeps track of positions visited
 * coords = all coords to add to hashmap when word found
 **/

fn dfs(board: & [&str], trie: &Trie, (x, y): (u8, u8), directions: &[(i8, i8)], path: &mut VecDeque<char>, visited: &mut HashSet<(u8, u8)>, coords: &mut VecDeque<(u8, u8)>, found: &mut HashMap<String, Vec<(u8, u8)>>) {
  
    //makes sure we can apply dfs to position
    if x < board.len() as u8 && y < board.len() as u8 && !visited.contains(&(x, y)) {

        //adds character at (x, y) to end of path
        path.push_back(board[x as usize].chars().nth(y as usize).unwrap());

        //creates the current word using all the path characters
        let new_word: String = path.iter().collect();

        //if the word is a prefix of a word in tree, then continue with dfs of this letter
        if trie.starts_with(&new_word) {
            //add position to visited stack, add to coords too
            visited.insert((x, y)); coords.push_back((x, y));
           
           //if it is a valid word
            if trie.search(&new_word) { 
                //add it to found hashmap
                found.insert(new_word.clone(), coords.make_contiguous().to_vec()); 
            }

            //repeat for neighbours
            for dir in directions { dfs(board, trie, ((x as i8 + dir.0) as u8, (y as i8 + dir.1) as u8), directions, path, visited, coords, found); }
            
            //once done, remove coordinates and move on
            visited.remove(&(x, y)); coords.pop_back();

        }

        //remove path
        path.pop_back();
    }
}


#[cfg(test)]
#[path = "tests.rs"]
mod tests;
