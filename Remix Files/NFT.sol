//SPDX-License-Identifier: None
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract P_NFTs is Context, Ownable, ERC721Enumerable{
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.AddressSet;

    /** @notice Capped max supply */
    uint256 public immutable supplyCap = 10000000;

    /** @notice Each address has a mint quota */
    uint16 public immutable quota = 2;
    public string [] image;
    string private _baseTokenURI;

    /** @notice Token ID counter declared */
    Counters.Counter private _tokenIds;
    /** @notice Freeze token base URI. Irrevocable */

    /** @notice Public mint open */

    /** @notice Mapping to track number of mints per address */
    mapping(address => uint256) public userMintCount;


    /** @notice Functions related to minting or changing
     * NFT metadata are inaccessible after freezing
     */

    constructor() ERC721("Beckys' NFT", "Becky") {
        _baseTokenURI = "ipfs://<temp CID>/";
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /** @notice Owner can change baseURI */
    function setBaseURI(string memory baseTokenURI)
        external
        onlyOwner
    {
        _baseTokenURI = baseTokenURI;
    }


    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     */
    function mintPNFT(string memory imageID) public {
        //require(msg.sender == tx.origin, "no bots");
       /* require(userMintCount[msg.sender] < quota, "Exceed quota");

        require(totalSupply() < supplyCap, "Exceed cap");
        */
        userMintCount[msg.sender]++;

        _mint(_msgSender(), _tokenIds.current() + 1, imageID);
        _tokenIds.increment();

    }

    /** @notice Contract owner can burn token he owns
     * @param _id token to be burned
     */
    function burn(uint256 _id) external onlyOwner {
        require(ownerOf(_id) == _msgSender());
        _burn(_id);
    }

    /** @notice Pass an array of address to batch mint
     * @param _recipients List of addresses to receive the batch mint
     */
    function batchMint(address[] calldata _recipients, string[] memory imageIDs) public+

    
    {
       /* require(
           totalSupply() + _recipients.length - 1 < supplyCap,
            "Exceed cap"
        );
*/
        for (uint256 i = 0; i < _recipients.length; i++) {
            _mint(_recipients[i], _tokenIds.current() + 1, imageIDs[i]);
            _tokenIds.increment();
        }
    }

    /** @notice Owner can batch mint to itself
     * @param _amount Number of tokens to be minted
     */
    function batchMintForOwner(uint256 _amount, string memory imageID) external onlyOwner {
       // require(totalSupply() + _amount - 1 < supplyCap, "Exceed cap");

        for (uint256 i = 0; i < _amount; i++) {
            _mint(_msgSender(), _tokenIds.current() + 1, imageID);
            _tokenIds.increment();
        }
    }

    /**
     * @dev Pauses all token transfers and mint
     */
    /** @notice Prevent most token functions being
     * called thereby freezing metadata */

    function totalMintCount() external view returns (uint256) {
        return _tokenIds.current();
    }

}
