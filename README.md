# <img src="avatar.png" alt="avatar" width="30" height="30" style="vertical-align: middle;"> Contributoor Dappnode Package 

Contributoor is a monitoring and data-gathering tool that runs alongside your beacon node, helping improve Ethereum's network visibility. This DAppNode package makes it easy to run Contributoor with your existing consensus client.

### 📦 Installation

1. Setting up the Environment:
    - Ensure you're running a full, synced Ethereum node (Execution client + Consensus client).
    - If you are not running a full Ethereum node yet, go to the Stakers Menu, select your clients and apply the configuration to start synchronization.
2. Package Installation:
    - In your Dappnode's UI, navigate to the DAppStore.
    - Find the Contributoor package of your desired network variant. 
        - [Install for Mainnet](http://my.dappnode/installer/dnp/contributoor-mainnet.dnp.dappnode.eth) 
        - [Install for Holesky](http://my.dappnode/installer/dnp/contributoor-holesky.dnp.dappnode.eth)
    - Click 'Install'. As part of the installation process, you will be asked to provide your credentials, these would have been provided to you by ethPandaOps.
3. Once installed, the Contributoor package should appear in your installed packages list.
4. The package will automatically detect your consensus client and configure itself appropriately.

### 🤔 Troubleshooting

- If the package can't detect your consensus client, verify that you have a supported client running
- Check the package logs for any connection issues with your beacon node
- For support, visit our [GitHub Issues](https://github.com/ethpandaops/contributoor/issues)

### 🔗 Links

- [What is Contributoor?](https://ethpandaops.io/posts/contributoor-beacon-node-companion/)
- [Contributoor](https://github.com/ethpandaops/contributoor)
- [ethPandaOps](https://ethpandaops.io)

### 🤝 Contributing

Contributoor is part of EthPandaOps' suite of tools for Ethereum network operations. Contributions are welcome! Please check our [GitHub repository](https://github.com/ethpandaops) for more information.

---

<details>
<summary>🛠 Development</summary>

You can get your IPFS address via the Dappnode Admin UI (Packages > System Packages > IPFS > Network). 
There you will find your container IP, with the IPFS port being 5001 by default.

```bash
dappnodesdk build --provider=IPFS_ADDRESS:5001 --variant=[mainnet|holesky]
```

If you want to build/test for all variants, you can replace `--variant` with `--all-variants`.

</details>

<details>
<summary>🔖 Publishing</summary>

By default, every 4 hours, the `auto_check` workflow will run. This will check for new versions `contributoor` and lodge a PR here with the version bump.

Once merged, the `main` workflow will run and publish a new version of the package. This will create a "pre-release". These pre-releases can be tested by searching the IPFS hash DAppStore within the Dappnode Admin UI (DAppNode > Dnp).

> Note: If you're testing a pre-release, you *must* change the IPFS repository address within the Dappnode Admin UI to `https://gateway-dev.ipfs.dappnode.io` (Repository > IPFS > Remote). The package will not be available under the default `https://gateway.ipfs.dappnode.io` until the package has been signed and promoted.
</details>
