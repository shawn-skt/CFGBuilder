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
├── 0aa91eb8d92a84cc9c8902f63a185d6ae5e87cff_HappyToken.sol
├── error
│   ├── 0b1fA4b11Edbcb6d35731549211D83C857fFBC0a_VotingStakingRewards.sol
│   └── 7fE1021378dd1e6F25042aA5f378c9da13de9680_CRC.sol
├── fe6e165757786bf49d121989f2fb6f3fa325bcef_VictoryGlobalCoin.sol
├── fe7f8a61d8b89f74c95ecb653c63fa245b08fc17_BancorKiller.sol
├── fe8b197c7da79a5a1ba07b7c45475f1820633927_lockEtherPay.sol
├── fe8b40a35ff222c8475385f74e77d33954531b41_XToken.sol
├── fe8c1c3e41960517b8c9fa83d9cf867b6275717f_IRECToken.sol
├── fe8eb5c34726bce6ef3fab63369f0772444a9a99_RNTDTokenCoin.sol
└── json
    ├── error
    │   ├── 0b1fA4b11Edbcb6d35731549211D83C857fFBC0a_VotingStakingRewards.sol.json
    │   └── 7fE1021378dd1e6F25042aA5f378c9da13de9680_CRC.sol.json
    ├── fe6e165757786bf49d121989f2fb6f3fa325bcef_VictoryGlobalCoin.sol.json
    ├── fe7f8a61d8b89f74c95ecb653c63fa245b08fc17_BancorKiller.sol.json
    ├── fe8b197c7da79a5a1ba07b7c45475f1820633927_lockEtherPay.sol.json
    ├── fe8b40a35ff222c8475385f74e77d33954531b41_XToken.sol.json
    ├── fe8c1c3e41960517b8c9fa83d9cf867b6275717f_IRECToken.sol.json
    ├── fe8eb5c34726bce6ef3fab63369f0772444a9a99_RNTDTokenCoin.sol.json
    └── fixed
        ├── 0aa91eb8d92a84cc9c8902f63a185d6ae5e87cff_HappyToken.sol.json
        ├── 0b1fA4b11Edbcb6d35731549211D83C857fFBC0a_VotingStakingRewards.sol.json
        └── 7fE1021378dd1e6F25042aA5f378c9da13de9680_CRC.sol.json
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