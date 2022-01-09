---------------------------
REPL
---------------------------
?
agents
agent <>
state
reset
exit
<return> 

help <agent>
help <flag>
help <arg>

---------------------------
STATE
---------------------------
.superwatch_state.yml

---
agent: ASDF
worker_flags: 
worker_args: 

---------------------------
ON STARTUP
---------------------------
- read config
- load state if it exists
- prompt for agent if not selected

