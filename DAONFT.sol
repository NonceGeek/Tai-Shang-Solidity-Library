// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAONFT is ERC721Enumerable, ReentrancyGuard, Ownable {
    string public rule; // setting only once, rule tx_id on arweave.
    string public baseURL; // setting only once
    string public walletDappCommitHash; // fixed walletDappCommitHash to make sure the dApp can't modified

    mapping(uint256 => string) tokenInfo;

    uint8[] private suffixes = [1, 2];

    uint8[] private units = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10
    ];

    uint8[] private multipliers = [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        0
    ];

    function getTokenInfo(uint256 _tokenId) public view returns (string memory) {
        return tokenInfo[_tokenId];
    }

    function setTokenInfo(uint256 _tokenId, string memory _tokenInfo) public onlyOwner {
        tokenInfo[_tokenId] = _tokenInfo;
    }
    function setbaseURL(string memory _baseURL) public onlyOwner {
        require(bytes(baseURL).length == 0, "baseURL is already set!");
        baseURL = _baseURL;
    }
    function setWalletDappCommitHash(string memory _commitHash) public onlyOwner {
        require(bytes(_commitHash).length == 0, "baseURL is already set!");
        walletDappCommitHash = _commitHash;
    }


    function setRule(string memory _rule) public onlyOwner {
        require(bytes(rule).length == 0, "rule is already set!");
        rule = _rule;
    }

    function getFirst(uint256 tokenId) public view returns (uint256) {
        return pluck(tokenId, "FIRST", units);
    }

    function getSecond(uint256 tokenId) public view returns (uint256) {
        return pluck(tokenId, "SECOND", units);
    }

    function getThird(uint256 tokenId) public view returns (uint256) {
        return pluck(tokenId, "THIRD", units);
    }
    function getFourth(uint256 tokenId) public view returns (uint256) {
        return pluck(tokenId, "FOURTH", units);
    }
    function getFifth(uint256 tokenId) public view returns (uint256) {
        return pluck(tokenId, "FIFTH", units);
    }

    function getSixth(uint256 tokenId) public view returns (uint256) {
        return pluck(tokenId, "SIXTH", units);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[24] memory parts;
        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
        parts[1] = "Badges: ";
        parts[2] = '</text><text x="10" y="40" class="base">';
        parts[3] = tokenInfo[tokenId];
        parts[4] = '</text><text x="10" y="60" class="base">';
        parts[5] = "See NFT rendered in: ";
        parts[6] = '</text><text x="10" y="80" class="base">';
        parts[7] = baseURL;
        parts[8] = "?token_id=";
        parts[9] = toString(tokenId);
        parts[10] = '</text><text x="10" y="100" class="base">';
        parts[11] = toString(getFirst(tokenId));
        parts[12] = '</text><text x="10" y="120" class="base">';
        parts[13] = toString(getSecond(tokenId));
        parts[14] = '</text><text x="10" y="140" class="base">';
        parts[15] = toString(getThird(tokenId));
        parts[16] = '</text><text x="10" y="160" class="base">';
        parts[17] = toString(getFourth(tokenId));
        parts[18] = '</text><text x="10" y="180" class="base">';
        parts[19] = toString(getFifth(tokenId));
        parts[20] = '</text><text x="10" y="200" class="base">';
        parts[21] = toString(getSixth(tokenId));
        parts[23] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(
                parts[0],
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parts[5],
                parts[6],
                parts[7],
                parts[8]
            )
        );

        output = string(
            abi.encodePacked(
                output,
                parts[9],
                parts[10],
                parts[11],
                parts[12],
                parts[13],
                parts[14],
                parts[15]
                )
        );

        output = string(
            abi.encodePacked(
                output,
                parts[16],
                parts[17],
                parts[18],
                parts[19],
                parts[20],
                parts[21],
                parts[22],
                parts[23]
                )
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "web3dev #',
                        toString(tokenId),
                        '", "description": "',
                        baseURL, 
                        '?token_id=',
                        toString(tokenId),
                        '", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }

    function claim(uint256 tokenId) public nonReentrant {
        _safeMint(_msgSender(), tokenId);
    }

    function pluck(
        uint256 tokenId,
        string memory keyPrefix,
        uint8[] memory sourceArray
    ) internal view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        uint256 output = sourceArray[rand % sourceArray.length];
        uint256 luck = rand % 21;
        if (luck > 14) {
            output += suffixes[rand % suffixes.length];
        }
        if (luck >= 19) {
            if (luck == 19) {
                output = (output * multipliers[rand % multipliers.length]) + suffixes[rand % suffixes.length];
            } else {
                output = (output * multipliers[rand % multipliers.length]);
            }
        }
        return output;
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }


    constructor() ERC721("web3dev", "W3D") Ownable() {
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}