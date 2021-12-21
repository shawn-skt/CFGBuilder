## Building from source (Linux & MacOs)

### Get the source code

Git and GitHub are used to maintain the source code. Clone the repository by:

```shell
git clone https://github.com/MingxiYe/CFGBuilder.git
cd CFGBuilder/src
```

### Install CMake

CMake is used to control the build configuration of the project.
We strongly recommend you to install CMake by downloading and unpacking the binary
distribution  of the latest version available on the
[**CMake download page**](https://cmake.org/download/).

The CMake package available in your operating system can also be installed
and used if it meets the minimum version requirement.

### Install dependencies

#### Linux

To be continued

#### MacOs

To be continued

### Data Clean

First you may need to preprocess your data/contracts.

We provide two bash files (`data_preprocess.sh` and `fix_err.sh`) to help you standardize your contract files.

```shell
./data_preprocess.sh contracts && ./fix_err.sh contracts
```

Specifically, you can run these bash files to filter those contracts in wrong format (can not be parsed by `solc`) or having unreachable imports like that.

```solidity
import "./interfaces/IVeXBE.sol";
import "./interfaces/IERC20.sol";
```

Notes: the bash parameter is your contract directory. The directory structure is like that.

```tree
.
├── xxxxxxx.sol
├── xxxxxxx.sol
├── ......
└── json
    ├── error
    │   └── xxxxxxx.json
    ├── fail2fix
    │   └── xxxxxxx.json
    ├── fix
    │   ├── xxxxxxxxxx.sol.json
    │   └── .......
    ├── xxxxxxxx.sol.json
    ├── ......
    └──
```

### Build

Configure the project build with the following command to create the
`build` directory with the configuration.

```shell
mkdir build; cd build  # Create a build directory.
cmake ..               # Configure the project.
make                   # Build fuzzer targets.
```

## construct the CFG of contracts
Place contracts to `contracts/`

```shell
./main -g && chmod +x cfgCon && ./cfgCon
```
The CFG will be stored in `outpus/json` in the form of json