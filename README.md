# Introduction

Tai Shang Solidity Library 是使用于 TaiShangVerse 及其他场合的合约。

包含如下四种基础合约：

## 0x01 DAO NFT Contract

> Contract on `Polygon Testnet`:
>
> https://mumbai.polygonscan.com/address/0xa9674c8c25a22de2a27a3d019f8759774e8e5f08#code
>
> Contract on `Moonbeam Mainnet`:
>
> https://moonbeam.moonscan.io/address/0xb6FC950C4bC9D1e4652CbEDaB748E8Cdcfe5655F#code
>
> See in `Opensea Testnet`:
>
> https://testnets.opensea.io/assets/mumbai/0xa9674c8c25a22de2a27a3d019f8759774e8e5f08/1

TaiShang DAO NFT 协议用于组织治理，NFT URI 是纯粹的链上 SVG。

<img width="269" alt="截屏2022-04-01 下午5 02 03" src="https://user-images.githubusercontent.com/12784118/161231650-c788f694-8572-4bcb-bef0-4048919f1271.png">

URI 中的元素如下：

- **Badges**

其中 Badges 是附着在 NFT 上的徽章，形态是一种自定义的`List`。

- **URL**

  指向能将该NFT 进行渲染的一个 URL 地址。

- **Nums**

  通过伪随机生成的六个数字，表示该 Token 的属性，这也是该 Token 能作为角色在元宇宙中使用的原因。

## 0x02 Normal NFT Contract

普通类型的 NFT 合约，URI 可存在 IPFS 或 Arweave 链上。

## 0x03 HTML NFT Contract

URL 类型为 HTML 的合约。

## 0x04 Abstract NFT Contract

抽象 NFT 合约，图像以 SVG 的形式直接存储于 NFT 中。

