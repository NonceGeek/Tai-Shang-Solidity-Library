// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// 合约的继承：https://learnblockchain.cn/article/1944
contract TaiShangVoxel is ERC1155Burnable, Ownable {
    // Using For: https://learnblockchain.cn/docs/solidity/0.6.12/contracts/using-for.html
    using Strings for uint256;
    using HexStrings for uint160;
    using Counters for Counters.Counter;
    Counters.Counter private tokenCounter;

    // ERC1155 没有这个，加进来？还是放到.json文件里面？
    string private _name;
    string private _symbol;

    // maping 类型: https://learnblockchain.cn/2017/12/27/solidity-structs
    mapping(uint256 => string[2]) public tokenURIs;
    mapping(uint256 => address) public creator;
    mapping(uint256 => bool) public verified;

    // TODO: 在github上面上传{id}.json描述文件，每mint一个nft应该就需要添加一个对应id的json描述文件
    constructor() public ERC1155("") {
        // Tai Shang Voxel
        _name = "Tai Shang Voxel";
        _symbol = "TSV";
    }

    // 函数可见性：https://learnblockchain.cn/docs/solidity/contracts.html#getter
    // 修改器：https://learnblockchain.cn/docs/solidity/contracts.html#modifier
    function verify(uint256 tokenId) public onlyOwner {
        // verified by owner
        verified[tokenId] = true;
    }

    // ============ ERC1155 没有实现的函数 ===========
    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address owner = creator[tokenId];
        require(
            owner != address(0),
            "TaiShangVoxel: owner query for nonexistent token"
        );
        return owner;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return creator[tokenId] != address(0);
    }

    // ============ PUBLIC FUNCTIONS FOR MINTING ============

    // External 会花费更少的gas费用
    function mint(
        string memory uri,
        string memory url,
        uint256 amount
    ) external returns (uint256) {
        uint256 _tokenId = nextTokenId();
        _mint(msg.sender, _tokenId, amount, "");
        tokenURIs[_tokenId][0] = uri;
        tokenURIs[_tokenId][1] = url;
        creator[_tokenId] = msg.sender;
        return _tokenId;
    }

    function mintBatch(
        string[] memory uris,
        string[] memory urls,
        uint256[] memory amounts
    ) external returns (uint256[] memory) {
        require(
            uris.length == urls.length,
            "TaiShangVoxel: uris and urls length mismatch"
        );
        uint256[] memory ids = new uint256[](uris.length);
        for (uint256 i = 0; i < uris.length; i++) {
            uint256 _tokenId = nextTokenId();
            ids[i] = _tokenId;
            tokenURIs[_tokenId][0] = uris[i];
            tokenURIs[_tokenId][1] = urls[i];
            creator[_tokenId] = msg.sender;
        }
        _mintBatch(msg.sender, ids, amounts, "");
        return ids;
    }

    // ============ PUBLIC READ-ONLY FUNCTIONS ============

    function getLastTokenId() external view returns (uint256) {
        return tokenCounter.current();
    }

    // ============ SUPPORTING FUNCTIONS ============

    function nextTokenId() private returns (uint256) {
        tokenCounter.increment();
        return tokenCounter.current();
    }

    function tokenImage(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Nonexistent token");
        return string(abi.encodePacked(tokenURIs[tokenId][0]));
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Nonexistent token");
        string memory name = string(
            abi.encodePacked("Tai Shang Voxel #", tokenId.toString())
        );
        string memory description = string(
            abi.encodePacked(
                "A Tai Shang Voxel token created by ",
                (uint160(creator[tokenId])).toHexString(20),
                ". To view the artwork, visit ",
                tokenURIs[tokenId][1],
                ".if verified by offcial:",
                verified[tokenId] ? "yes" : "no"
            )
        );
        string memory image = tokenImage(tokenId);

        return
            // https://learnblockchain.cn/docs/solidity/cheatsheet.html
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"',
                                description,
                                '", "attributes": []',
                                ', "creator":"',
                                (uint160(creator[tokenId])).toHexString(20),
                                '", "image": "',
                                tokenURIs[tokenId][1],
                                '", "external_url": "',
                                tokenURIs[tokenId][1],
                                '", "animation_url": "',
                                tokenURIs[tokenId][1],
                                '", "uri": "',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}

library HexStrings {
    bytes16 internal constant ALPHABET = "0123456789abcdef";

    function toHexString(uint256 value, uint256 length)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = ALPHABET[value & 0xf];
            value >>= 4;
        }
        return string(buffer);
    }
}

// File base64-sol/base64.sol@v1.1.0

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides functions for encoding/decoding base64
library Base64 {
    string internal constant TABLE_ENCODE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    bytes internal constant TABLE_DECODE =
        hex"0000000000000000000000000000000000000000000000000000000000000000"
        hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
        hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
        hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE_ENCODE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                // read 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // write 4 characters
                mstore8(
                    resultPtr,
                    mload(add(tablePtr, and(shr(18, input), 0x3F)))
                )
                resultPtr := add(resultPtr, 1)
                mstore8(
                    resultPtr,
                    mload(add(tablePtr, and(shr(12, input), 0x3F)))
                )
                resultPtr := add(resultPtr, 1)
                mstore8(
                    resultPtr,
                    mload(add(tablePtr, and(shr(6, input), 0x3F)))
                )
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }

    function decode(string memory _data) internal pure returns (bytes memory) {
        bytes memory data = bytes(_data);

        if (data.length == 0) return new bytes(0);
        require(data.length % 4 == 0, "invalid base64 decoder input");

        // load the table into memory
        bytes memory table = TABLE_DECODE;

        // every 4 characters represent 3 bytes
        uint256 decodedLen = (data.length / 4) * 3;

        // add some extra buffer at the end required for the writing
        bytes memory result = new bytes(decodedLen + 32);

        assembly {
            // padding with '='
            let lastBytes := mload(add(data, mload(data)))
            if eq(and(lastBytes, 0xFF), 0x3d) {
                decodedLen := sub(decodedLen, 1)
                if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
                    decodedLen := sub(decodedLen, 1)
                }
            }

            // set the actual output length
            mstore(result, decodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 4 characters at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                // read 4 characters
                dataPtr := add(dataPtr, 4)
                let input := mload(dataPtr)

                // write 3 bytes
                let output := add(
                    add(
                        shl(
                            18,
                            and(
                                mload(add(tablePtr, and(shr(24, input), 0xFF))),
                                0xFF
                            )
                        ),
                        shl(
                            12,
                            and(
                                mload(add(tablePtr, and(shr(16, input), 0xFF))),
                                0xFF
                            )
                        )
                    ),
                    add(
                        shl(
                            6,
                            and(
                                mload(add(tablePtr, and(shr(8, input), 0xFF))),
                                0xFF
                            )
                        ),
                        and(mload(add(tablePtr, and(input, 0xFF))), 0xFF)
                    )
                )
                mstore(resultPtr, shl(232, output))
                resultPtr := add(resultPtr, 3)
            }
        }

        return result;
    }
}
