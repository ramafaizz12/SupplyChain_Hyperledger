export CALIPER_BENCHCONFIG=benchmarks/config.yaml
export CALIPER_NETWORKCONFIG=networks/fabric/network-config.yaml
  
npx caliper  launch manager  --caliper-fabric-gateway-enabled --calper-flow-only-test --caliper-fabric-gateway-discovery=false 
# fungsibaru


fungsibaru() {
npx caliper launch manager \
--caliper-workspace . \
--caliper-benchconfig benchmarks/config.yaml \
--caliper-networkconfig networks/fabric/network-config.yaml
}