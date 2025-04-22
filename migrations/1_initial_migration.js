const CrowdFunding = artifacts.require("CrowdFunding");

module.exports = function (deployer) {
  const goalInWei = web3.utils.toWei("1", "ether"); // contoh goal: 1 ETH
  deployer.deploy(CrowdFunding, goalInWei);
};
