# Superwatch 

## CLI Challenge

Wanted: getch, readline, tab completion

Notes:
- impossible with gets
- impossible with nif 
- seems impossible with port (exe can't read stdin..)
- could it be done with NCurses?  (one-line? full-screen?)
- And yet: IEx does it!

Approach:
- near term: gets-style CLI only
- long term: study IEx, emulate it's features, release as lib

## 2022 Jan 18 Tue

- [x] Drop Worker 
- [x] Rename runner to worker
- [x] Fix CaptureIO (Process Leader...)
- [x] Remove streamio from state

## 2022 Jan 19 Wed

- [x] Implement Manager as Module not Escript
- [x] Design Config and State settings
- [x] Refactor module names
- [x] Create CLI framework

## 2022 Jan 31 Mon

- [x] Short-term Elixir CLI: no tab completion

## 2022 Feb 01 Tue

- [x] add help system 
- [x] successful test with Ports launching Nvim 

## TODO

Editor:
- [ ] Make a util/editor module 
- [ ] Add an editor.launch function 

Agent Command: 
- [ ] initialize a config file 
- [ ] read agents from config file 
- [ ] read agent from config file 

Set & State Commnand: 
- [ ] read state 
- [ ] write state 

Near Term: 
- [ ] update state
- [ ] finish runner

Release:
- [ ] Add release config 
- [ ] Add Burrito config 
- [ ] Create release page with burrito executables

Long Term:
- [ ] Add tab completion

