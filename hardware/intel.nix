{ config, ... }:

{
  hardware.cpu.intel.updateMicrocode = config.hardware.cpu.intel.enable;
}
