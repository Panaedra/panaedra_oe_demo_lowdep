# Demonstration of the Paneadra Python Bridge from the Progress OpenEdge ABL

This demo is marked as `lowdep`, meaning **Low on Dependencies**. This means that it is not dependant on the real Panaedra OpenEdge Platform.

This lowdep demo is useful for demonstration purposes: You see the pure interaction with the Python Bridge.

Do not depend on the code in this repo. It may be outdated or even fall over, and will not follow the latest developments.

## Run

1. Install Progress OpenEdge 11.7 Linux x64 on your Vagrant VM (see panaedra_c_pythonbridge repository)
    * We used as destination: `/usr/bin/dlc117/`
    * You will need a Developer License
1. Pull the repository to: `/panaedra/panaedra_oe_demo_lowdep`
1. Run the lowdep test procedure:
    ```bash
    cd ~
    . /usr/bin/dlc117/bin/proenv
    # Propath explained:
    #   (1) root path of gcc compiled shared object,
    #   (2) root path of test namespace,
    #   (3) root path of src namespace,
    PROPATH="/panaedra/panaedra_c_pythonbridge/src:/panaedra/panaedra_oe_demo_lowdep/test:/panaedra/panaedra_oe_demo_lowdep/src" pro -p "test_panaedra/msroot/mspy/logic/c_mspython_sys_interpreter_lowdep_idetest.p"

    ```
1. Screenshot:
    ```screen
    ┌────────────────── Message ──────────────────┐
    │ Python interpreter has started succesfully. │
    │ ─────────────────────────────────────────── │
    │                    <OK>                     │
    └─────────────────────────────────────────────┘
    ```
1. Screenshot:
    ```screen
    ┌───────────────────────────────── Message ─────────────────────────────────┐
    │            Succesfully compiled and allocated Python fragment:            │
    │                                                                           │
    │ import sys;cDataOP='Hello Panaedra Python Bridge world\n'+repr(sys.path)  │
    │ ───────────────────────────────────────────────────────────────────────── │
    │                                   <OK>                                    │
    └───────────────────────────────────────────────────────────────────────────┘
    ```
1. Screenshot:
    ```screen
    ┌────────────────────────────────── Message ───────────────────────────────────┐
    │                    Succesfully executed Python fragment:                     │
    │                                                                              │
    │   import sys;cDataOP='Hello Panaedra Python Bridge world\n'+repr(sys.path)   │
    │                                                                              │
    │                                   Output:                                    │
    │                                                                              │
    │                      Hello Panaedra Python Bridge world                      │
    │      ['/usr/lib/python2.7', '/usr/lib/python2.7/plat-x86_64-linux-gnu',      │
    │          '/usr/lib/python2.7/lib-tk', '/usr/lib/python2.7/lib-old',          │
    │ '/usr/lib/python2.7/lib-dynload', '/usr/local/lib/python2.7/dist-packages',  │
    │                     '/usr/lib/python2.7/dist-packages']                      │
    │ ──────────────────────────────────────────────────────────────────────────── │
    │                                     <OK>                                     │
    └──────────────────────────────────────────────────────────────────────────────┘
    ```
1. Screenshot:
    ```screen
    ┌──────────────── Message ────────────────┐
    │ Python interpreter has exited normally. │
    │ ─────────────────────────────────────── │
    │                  <OK>                   │
    └─────────────────────────────────────────┘
    ```
1. And you are back at the prompt, end of demo.
