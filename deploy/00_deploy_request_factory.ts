import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

const deployRequestFactory: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const provider = ethers.provider;
  const from = await provider.getSigner().getAddress();

  const storageManager = "0x0000000000000000000000000000000000000000";
  const ret = await hre.deployments.deploy("RequestFactory", {
    from,
    args: [storageManager],
    gasLimit: 6e6,
    deterministicDeployment: true,
  });
  console.log("==RequestFactory addr=", ret.address);
};

export default deployRequestFactory;
