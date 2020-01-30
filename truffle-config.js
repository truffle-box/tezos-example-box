module.exports = {
  // see <http://truffleframework.com/docs/advanced/configuration>
  // for more details on how to specify configuration options!
  networks: {
    development: {
      host: "https://api.tez.ie/rpc/babylonnet",
      port: 443,
      network_id: "*",
      type: "tezos"
    },
    zeronet: {
      host: "https://rpczero.tzbeta.net",
      port: 443,
      network_id: "*",
      type: "tezos"
    }
  }
};
