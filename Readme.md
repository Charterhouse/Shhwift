Shhwift
=======

A client for the [Ethereum Whisper][1] communication protocol, written in Swift.

### Running an ethereum node

Shhwift currently requires a running Ethereum node with Whisper enabled on the JSON-RPC interface. For instance, by running [Ethereum Go][2] with the following parameters:

    geth --shh --rpc --rpcapi "shh"

### Enabling Peer-to-peer messaging

The default Ethereum boot nodes currently do not run Whisper. This means that you won't be able to participate in the Whisper peer-to-peer network, unless you explicitly use a Whisper node as bootnode. 

You can run such a bootnode yourself by running ``geth --shh`` and use the enode url that it prints upon startup as the bootnode argument for the other nodes:

    geth --shh --rpc --rpcapi "shh" --bootnodes enode://<public key>@<ip address>:30303 

[1]: https://github.com/ethereum/wiki/wiki/Whisper
[2]: https://github.com/ethereum/go-ethereum
