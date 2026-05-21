const { ethers } = require("ethers");

/**
 * Verifies a Merkle proof submitted by a storage node
 */
function verifyDataAvailability(root, leaf, index, proof, treeDepth) {
    let hash = leaf;
    for (let i = 0; i < proof.length; i++) {
        const proofElement = proof[i];
        if (index % 2 === 0) {
            hash = ethers.keccak256(ethers.concat([hash, proofElement]));
        } else {
            hash = ethers.keccak256(ethers.concat([proofElement, hash]));
        }
        index = Math.floor(index / 2);
    }
    return hash === root;
}

module.exports = { verifyDataAvailability };
