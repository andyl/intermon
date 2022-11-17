# Superwatch

Superwatch provides interactive supervision for file monitor and worker
programs.  Superwatch is useful for software development, watching for file
changes and automatically running regression tests.

## Superwatch Executables

| Execution Method   | Status | Note                       |
|--------------------|--------|----------------------------|
| Escript            | Fails  | MuonTrap failure           |
| Burrito Executable | Fails  | Hangs, needs investigation |
| IEX                | Works  | OK for dev                 |
| Mix Release        | Works  | OK for dev                 |
| Elixir Script      | Works  | Best option for now        |

See the repo `andyl/mt_demo` for more info on Muon and Burrito.

## Getting Started

    > # get help
    > superwatch help
    >
    > # generate a superwatch config file
    > superwatch init 
    >
    > # start superwatch
    > cd <YOURPROJECT>
    > superwatch start

## Superwatch Config

The Superwatch config file is stored your root directory at `~/.superwatch.yml`.

    ---
    ex_unit:
      desc: ExUnit for Elixir Project
      monitor_command: watchexec -c -w lib -w test -e ex,exs,eex,heex "<%= worker_command %>"
      worker_command: mix test <%= worker_flags %> <%= worker_opts %> --stale ; echo ---
      worker_exit: /^---$/
      worker_flags:
        focus: 
          alias: f
          desc: Run only focus tests
          longdesc: |
            Only run specific tests, using ExUnit's `tag` feature
    
                @tag focus
                test "mytest" do 
                  assert 1 == 1
                end
          default: false
          output: "--only focus:true" 
      worker_opts:
        only: 
          alias: o
          desc: Only run tests that match the filter
          default: false
          output: "--only <%= value %>" 
    ex_unit_umbrella: 
      import: [ex_unit]
      desc: ExUnit for Elixir Umbrella Project
      monitor_command: watchexec -c -w apps -e ex,exs,eex,heex "<%= worker_command %>"

## Superwatch State 

The Superwatch state file is stored in the project root directory at
`<project>/.superwatch_state.yml`.  Be sure to add `.superwatch_state.yml` to
your `.gitignore` file.

    ---
    agent: ex_unit
    monitor_flags: []
    monitor_opts: []
    worker_flags: [-f]
    worker_opts: []

## Comparable Projects

Here are some excellent file watcher programs.  

| Project                    | Language   | Interactive? |
|----------------------------|------------|--------------|
| [fswatch][f]               | Agnostic   | no           |
| [entr][e]                  | Agnostic   | no           |
| [watchexec][w]             | Agnostic   | no           |
| [guard][g]                 | Ruby       | no           |
| [jest][j] [watch][ji]      | Javascript | yes          |
| [mix_test_watch][mw]       | Elixir     | no           |
| [mix_test_interactive][mi] | Elixir     | yes          |

Superwatch is language agnostic and interactive.

[f]: https://emcrisostomo.github.io/fswatch/
[e]: http://eradman.com/entrproject/
[w]: https://watchexec.github.io/
[g]: https://github.com/guard/guard
[j]: https://jestjs.io/
[ji]: https://egghead.io/lessons/javascript-use-jest-s-interactive-watch-mode 
[mw]: https://hex.pm/packages/mix_test_watch
[mi]: https://hexdocs.pm/mix_test_interactive/readme.html

## Contributing

Issues and PRs welcome!

