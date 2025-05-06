# Description

This project calculates the tax of each trade in a list.

## Input:

```ocaml
let input = [
    Buy  { unit_cost = 10.; quantity = 100 };
    Sell { unit_cost = 15.; quantity = 50  };
    Sell { unit_cost = 15.; quantity = 50  };
]
(* : trade list *)
```

Where trade is defined as follows:

```ocaml
type data = { unit_cost : float ; quantity : int }
type trade = Buy of data | Sell of data
```

## Output:

```ocaml
let output = [None; None; Some 1000.]
(* : float option list *);
```

---

# Config

If you already have OCaml installed in your OS you can skip this step and jump to [Create a Switch for Your ](#create-a-switch-for-your-project) section right away.

## Install Opam

### For macOS

```sh
brew install opam
```

### For Linux

```sh
sudo apt-get install opam
```

### For Windows

```sh
winget install Git.Git OCaml.opam
```

## Global Setup

Initialize OCaml's global configuration with Opam:

```sh
opam init -y
```

Activate the **Opam** global configuration by running:

```sh
eval $(opam env)
```

**Note:** add this command to your `.bashrc` or equivalent.

### Install Platform Tools

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

---

# Create a Switch for Your Project

Create a switch with your selected version:

```sh
opam switch create . 5.3.0 --deps-only
```

## Activate the Switch

Activate the switch every time you enter the project:

```sh
eval $(opam env)
```

## Install Switch Tools

```sh
opam install ocaml-lsp-server odoc ocamlformat alcotest
```

---

# Run

## Build and Execute

Use watch mode to build and execute the program

```sh
dune exec -w ocaml-trade-tax
```

## Run Tests

```sh
dune test -w
```
