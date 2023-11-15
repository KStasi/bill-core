import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

const deployERC20PaymentProxy: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const provider = ethers.provider;
  const from = await provider.getSigner().getAddress();

  const ret = await hre.deployments.deploy("ERC20PaymentProxy", {
    from,
    args: [],
    gasLimit: 6e6,
    deterministicDeployment: true,
  });
  console.log("==ERC20PaymentProxy addr=", ret.address);
};

export default deployERC20PaymentProxy;
