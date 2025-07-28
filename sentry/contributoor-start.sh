#!/bin/bash

ERROR="[ ERROR ]"
WARN="[ WARN ]"
INFO="[ INFO ]"

# shellcheck disable=SC1091
. /etc/profile

# Determine NETWORK based on which client variables are set.
if [ -n "$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET" ] || [ -n "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_MAINNET" ]; then
    export NETWORK="mainnet"
elif [ -n "$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_HOLESKY" ] || [ -n "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_HOLESKY" ]; then
    export NETWORK="holesky"
elif [ -n "$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_HOODI" ] || [ -n "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_HOODI" ]; then
    export NETWORK="hoodi"
else
    echo "${ERROR} Could not determine NETWORK from DAppNode global variables"
    exit 1
fi

# Get consensus client from network-specific env var
NETWORK_UPPER=$(echo "$NETWORK" | tr '[:lower:]' '[:upper:]')
CONSENSUS_CLIENT_VAR="_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_${NETWORK_UPPER}"
CONSENSUS_CLIENT="${!CONSENSUS_CLIENT_VAR}"

# Build beacon node URL based on client and network
case "$NETWORK" in
    "mainnet")
        case "$CONSENSUS_CLIENT" in
            "prysm.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.prysm.dappnode:3500"
                ;;
            "teku.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.teku.dappnode:3500"
                ;;
            "lighthouse.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.lighthouse.dappnode:3500"
                ;;
            "nimbus.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.nimbus.dappnode:3500"
                ;;
            "lodestar.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.lodestar.dappnode:3500"
                ;;
            *)
                echo "${ERROR} Unknown or unsupported mainnet consensus client: ${CONSENSUS_CLIENT}"
                exit 1
                ;;
        esac
        ;;
    "holesky")
        case "$CONSENSUS_CLIENT" in
            "prysm-holesky.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.prysm-holesky.dappnode:3500"
                ;;
            "teku-holesky.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.teku-holesky.dappnode:3500"
                ;;
            "lighthouse-holesky.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.lighthouse-holesky.dappnode:3500"
                ;;
            "nimbus-holesky.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.nimbus-holesky.dappnode:3500"
                ;;
            "lodestar-holesky.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.lodestar-holesky.dappnode:3500"
                ;;
            *)
                echo "${ERROR} Unknown or unsupported holesky consensus client: ${CONSENSUS_CLIENT}"
                exit 1
                ;;
        esac
        ;;
    "hoodi")
        case "$CONSENSUS_CLIENT" in
            "prysm-hoodi.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.prysm-hoodi.dappnode:3500"
                ;;
            "teku-hoodi.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.teku-hoodi.dappnode:3500"
                ;;
            "lighthouse-hoodi.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.lighthouse-hoodi.dappnode:3500"
                ;;
            "nimbus-hoodi.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.nimbus-hoodi.dappnode:3500"
                ;;
            "lodestar-hoodi.dnp.dappnode.eth")
                BEACON_NODE_ADDR="http://beacon-chain.lodestar-hoodi.dappnode:3500"
                ;;
            *)
                echo "${ERROR} Unknown or unsupported hoodi consensus client: ${CONSENSUS_CLIENT}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "${ERROR} Unknown network: ${NETWORK}"
        exit 1
        ;;
esac

# Dump some info.
echo "${INFO} Initializing contributoor service"
echo "${INFO} - NETWORK: ${NETWORK}"
echo "${INFO} - CONSENSUS_CLIENT: ${CONSENSUS_CLIENT}"
echo "${INFO} - CONTRIBUTOOR_USERNAME: ${CONTRIBUTOOR_USERNAME}"
echo "${INFO} - BEACON_URL: ${BEACON_NODE_ADDR}"
echo "${INFO} - ATTESTATION_CONTRIBUTION: ${CONTRIBUTOOR_ATTESTATION_CONTRIBUTION:-false}"

# Build attestation flag if enabled
ATTESTATION_FLAG=""
if [ "${CONTRIBUTOOR_ATTESTATION_CONTRIBUTION}" = "true" ]; then
    ATTESTATION_FLAG="--attestation-subnet-check-enabled"
    echo "${INFO} Attestation contribution enabled"
fi

# Run contributoor.
exec /usr/local/bin/contributoor --network "${NETWORK}" \
    --beacon-node-address "${BEACON_NODE_ADDR}" \
    --log-level "info" \
    --username "${CONTRIBUTOOR_USERNAME}" \
    --password "${CONTRIBUTOOR_PASSWORD}" \
    --output-server-address "xatu.primary.production.platform.ethpandaops.io:443" \
    --output-server-tls "true" \
    ${ATTESTATION_FLAG}
