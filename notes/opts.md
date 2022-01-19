---------------------------
REPL
---------------------------
|----------------------|------|
| CMD                  | DESC |
|----------------------|------|
| ?                    |      |
| state                |      |
| reset                |      |
| exit                 |      |
| run                  |      |
| <return>             |      |
|----------------------|------|
| agent                |      |
| agent init <agent>   |      |
| agent use <agent>    |      |
| agent saveas <agent> |      |
| agent delete <agent> |      |
| agent list           |      |
| agent list all       |      |
|----------------------|------|
| set                  |      |
| set clearscreen <al> |      |
| set command <val>    |      |
| set dirs <val>       |      |
| set filter <val>     |      |
| set ftypes <val>     |      |
| set arg <string>     |      |
|----------------------|------|
| help                 |      |
| help state           |      |
| help reset           |      |
| help exit            |      |
| help run             |      |
|----------------------|------|
| help agent...        |      |
| help set...          |      |
|----------------------|------|

---------------------------
STATE
---------------------------
.superwatch_state.yml
top item is default 
reset clears

---------------------------
ON STARTUP
---------------------------
- read config
- load state if it exists

---------------------------
PROMPT
---------------------------
Superwatch | ex_unit +stale (? for help)> 




